{ pkgs, ... }:
{
  home.file = {
    "assets/wallpapers" = {
      source = ./downloaded;
      recursive = true;
    };
    "assets/wallpapers/sylvain-sarrailh-danghostisland.jpg".source = pkgs.fetchurl {
      url = "https://cdnb.artstation.com/p/assets/images/images/066/557/945/large/sylvain-sarrailh-danghostisland.jpg";
      hash = "sha256-AxhO0s6dZG467m9zezK/DfkhX8peaEhbQxPRDLjFaSg=";
    };
    "assets/wallpapers/jama-jurabaev-ridge-by-jamajurabaev.jpg".source = pkgs.fetchurl {
      url = "https://cdnb.artstation.com/p/assets/images/images/004/898/069/large/jama-jurabaev-ridge-by-jamajurabaev-d5lkq34.jpg";
      hash = "sha256-9/E7cJ7DPEVFOa7bCS5ZtowUDUwkoZyEaw/zLAjr3Vw=";
    };
    "assets/wallpapers/jonathan-lebrec-car-ride-3.jpg".source = pkgs.fetchurl {
      url = "https://cdna.artstation.com/p/assets/images/images/059/149/066/large/jonathan-lebrec-car-ride-3.jpg";
      hash = "sha256-h2rGgul9rYLJcaErW/g/FKgtme2t2pJXHEiZGYIHJuE=";
    };
    "assets/wallpapers/space-gooose-spacehawks-as-1.jpg".source = pkgs.fetchurl {
      url = "https://cdna.artstation.com/p/assets/images/images/088/441/324/large/space-gooose-spacehawks-as-1.jpg";
      hash = "sha256-7betoO2W1jn2NBxrq4cJt76cS0F0jqT3LZ4ZXk/zXXA=";
    };
  };
}
