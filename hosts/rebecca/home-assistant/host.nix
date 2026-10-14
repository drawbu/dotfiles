{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) escapeShellArg getExe getExe';

  # %{http_code} is quoted because curl renders it as the literal `000` on a
  # transport-level failure, and `000` is not a valid JSON number.
  writeOut = ''{"code":"%{http_code}","latency":%{time_total}}'';

  # curl still writes the document on those failures, it just also exits
  # non-zero, and command_line discards the whole update on a non-zero exit.
  probe =
    host:
    lib.concatStringsSep " " [
      (getExe pkgs.curl)
      "--silent --location --max-time 10 --output /dev/null"
      "--write-out ${escapeShellArg writeOut}"
      "https://${host}"
      "|| true"
    ];

  probes = import ./probes.nix { inherit config lib; };

  awk = getExe pkgs.gawk;
  df = getExe' pkgs.coreutils "df";

  diskUsage = label: path: {
    name = "${label} disk";
    unique_id = "host_disk_${lib.toLower label}";
    command = "${df} --output=pcent ${path}";
    value_template = "{{ value.split()[-1] | replace('%', '') | int }}";
    unit_of_measurement = "%";
    state_class = "measurement";
    scan_interval = 600;
    icon = "mdi:harddisk";
  };

  loadAverage = minutes: field: {
    name = "Load ${toString minutes}m";
    unique_id = "host_load_${toString minutes}m";
    command = "${awk} '{ print \$${toString field} }' /proc/loadavg";
    state_class = "measurement";
    scan_interval = 60;
    icon = "mdi:speedometer";
  };
in
{
  services.home-assistant = {
    extraComponents = [
      "command_line"
      "template"
    ];

    config = {
      command_line =
        map (p: {
          sensor = {
            name = "${p.host} probe";
            unique_id = "probe_${p.id}";
            command = probe p.host;
            command_timeout = 15;
            scan_interval = 120;
            value_template = "{{ value_json.code | int(0) }}";
            json_attributes = [ "latency" ];
          };
        }) probes
        ++ map (sensor: { inherit sensor; }) [
          {
            name = "Failed units";
            unique_id = "systemd_failed_units";
            command = "${getExe' pkgs.systemd "systemctl"} list-units --failed --output=json | ${getExe pkgs.jq} --compact-output '{count: length, units: map(.unit)}'";
            value_template = "{{ value_json.count }}";
            json_attributes = [ "units" ];
            state_class = "measurement";
            scan_interval = 300;
            icon = "mdi:alert-circle-outline";
          }
          {
            name = "Memory usage";
            unique_id = "host_memory_usage";
            command = "${awk} ${escapeShellArg ''/^MemTotal:/ { t = $2 } /^MemAvailable:/ { a = $2 } END { printf "%.1f", 100 * (t - a) / t }''} /proc/meminfo";
            unit_of_measurement = "%";
            state_class = "measurement";
            scan_interval = 60;
            icon = "mdi:memory";
          }
          (diskUsage "Root" "/")
          (diskUsage "Boot" "/boot")
          (loadAverage 1 1)
          (loadAverage 15 3)
          {
            name = "Last boot";
            unique_id = "host_last_boot";
            command = "${awk} '/^btime/ { print $2 }' /proc/stat";
            value_template = "{{ value | int | as_datetime }}";
            device_class = "timestamp";
            scan_interval = 3600;
          }
          {
            name = "Last deploy";
            unique_id = "host_last_deploy";
            command = "${getExe' pkgs.coreutils "stat"} --format=%Y /nix/var/nix/profiles/system";
            value_template = "{{ value | int | as_datetime }}";
            device_class = "timestamp";
            scan_interval = 300;
            icon = "mdi:nix";
          }
        ];

      template = [
        {
          binary_sensor = map (p: {
            name = "${p.host} online";
            unique_id = "probe_${p.id}_online";
            device_class = "connectivity";
            state = "{% set code = states('sensor.${p.id}_probe') | int(0) %}{{ 200 <= code and code < 400 }}";
          }) probes;
          sensor = map (p: {
            name = "${p.host} latency";
            unique_id = "probe_${p.id}_latency";
            device_class = "duration";
            unit_of_measurement = "ms";
            state_class = "measurement";
            # code 0 means the request never completed, so there is no latency to
            # record; without this the statistics take a 0ms sample on every miss.
            availability = "{{ states('sensor.${p.id}_probe') | int(0) > 0 }}";
            state = "{{ (state_attr('sensor.${p.id}_probe', 'latency') | float(0) * 1000) | round(1) }}";
          }) probes;
        }
      ];
    };
  };
}
