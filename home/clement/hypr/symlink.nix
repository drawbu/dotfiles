{
  pkgs,
  path,
  file,
  default,
  ...
}: {
  script = pkgs.writeShellScript "activation" ''
    file="${path}/${file}"

    [ -f $file ] || ln -s "${path}/${default}" $file
  '';
}
