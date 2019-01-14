{ iHaskellWith }:

iHaskellWith {
  name="cities-wordcloud";
  packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      }
