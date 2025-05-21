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
  };
}
