{ ... }: {
  networking.extraHosts = ''
    # 127.0.0.1 www.facebook.com
    # 127.0.0.1 www.youtube.com
    127.0.0.1 www.twitter.com
    127.0.0.1 www.x.com
    127.0.0.1 www.instagram.com
  '';
}
