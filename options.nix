{lib, ...}: {
  options = {
    user = {
      email = lib.mkOption {
        type = lib.types.str;
        default = "kamil.krawczyk87@gmail.com";
      };
    };
    host = {
      isLinux = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      profile = lib.mkOption {
        type = lib.types.str;
        default = "private";
      };
    };
  };
}
