{
  pkgs,
  path,
  file,
  default,
  lib,
  ...
}:
{
  script = lib.getExe (
    pkgs.writeShellApplication {
      name = "activation";
      text = ''
        file="${path}/${file}"
        [ -f "$file" ] || ln -s "${path}/${default}" "$file"
      '';
    }
  );
}
