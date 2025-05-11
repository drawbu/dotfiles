{
  pkgs,
  path,
  file,
  default,
  ...
}:
{
  script = pkgs.lib.getExe (
    pkgs.writeShellApplication {
      name = "activation";
      text = ''
        file="${path}/${file}"
        [ -f "$file" ] || ln -s "${path}/${default}" "$file"
      '';
    }
  );
}
