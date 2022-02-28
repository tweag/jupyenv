{
  data_uri = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzkxgdxrlbfl4537y3n9mjxbm28kir639gcw3x47ffchwsgdcky";
      type = "gem";
    };
    version = "0.1.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0";
      type = "gem";
    };
    version = "1.15.5";
  };
  ffi-rzmq = {
    dependencies = ["ffi-rzmq-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14a5kxfnf8l3ngyk8hgmk30z07aj1324ll8i48z67ps6pz2kpsrg";
      type = "gem";
    };
    version = "2.0.7";
  };
  ffi-rzmq-core = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0amkbvljpjfnv0jpdmz71p1i3mqbhyrnhamjn566w0c01xd64hb5";
      type = "gem";
    };
    version = "1.0.7";
  };
  io-console = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "7e2418376fd185ad66e7aee2c58c207e9be0f2197aa89bc4c89931995cee3365";
      type = "gem";
    };
    version = "0.5.11";
  };
  irb = {
    dependencies = ["reline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "4a6698d9ab9de30ffd2def6fb17327f5d0fc089ace62337eff95396f379bf0a8";
      type = "gem";
    };
    version = "1.4.1";
  };
  iruby = {
    dependencies = ["data_uri" "ffi-rzmq" "irb" "mime-types" "multi_json" "native-package-installer" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "cc219e2ac797c3fbf8c2b937ee7d26547723c8ae0e5ad65f2975aa3325b3a620";
      type = "gem";
    };
    version = "0.7.4";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "6bcf8b0e656b6ae9977bdc1351ef211d0383252d2f759a59ef4bcf254542fc46";
      type = "gem";
    };
    version = "3.4.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "d8c401ba9ea8b648b7145b90081789ec714e91fd625d82c5040079c5ea696f00";
      type = "gem";
    };
    version = "3.2022.0105";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fd04138b6e4a90017e8d1b804c039031399866ff3fbabb7822aea367c78615d";
      type = "gem";
    };
    version = "1.15.0";
  };
  native-package-installer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "ba899df70489b748a3fe1b48afe6325d1cb8ca67fdff759266c275b911c797dd";
      type = "gem";
    };
    version = "1.1.3";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "5ce4bf5037b4196c24ac62834d8db1ce175470391026bd9e557d669beeb19097";
      type = "gem";
    };
    version = "13.0.6";
  };
  reline = {
    dependencies = ["io-console"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "b101d93607bf7564657f082f68abfa19ae939d14a709eff89be048eae2d7f4c7";
      type = "gem";
    };
    version = "0.3.1";
  };
}
