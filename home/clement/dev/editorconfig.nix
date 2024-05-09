{...}: {
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_size = 4;
        indent_style = "space";
        insert_final_newline = true;
        max_line_length = 80;
        tab_width = 4;
        trim_trailing_whitespace = true;
      };
      "{Makefile,*.mk}" = {
        indent_style = "tab";
      };
      "*.{nix,yml,asm,s,S,lua}" = {
        indent_size = 2;
      };
    };
  };
}
