{ pkgs, ... }:
let
  greeting = pkgs.writeScriptBin "greeting" ''
    #!${pkgs.nushell}/bin/nu

    let quotes = [
      "What is impossible for you is not impossible for me."
      "Why do we fall, Master Wayne? So that we can learn to pick ourselves up. - Alfred Pennyworth"
      "Endure, Master Wayne. Take it. They'll hate you for it, but that's the point of Batman. He can be the outcast. He can make the choice that no one else can make. The right choice. - Alfred Pennyworth"
      "— I never said thank you.\n— And you will never have to."
      "A hero can be anyone, even a man doing something as simple and reassuring as putting a coat on a young boy's shoulders to let him know that the world hadn't ended. - Batman"
      "— Come with me. Save yourself. You don't owe these ppl anymore, you've given them everything.\n— Not everything. Not yet."
      "The night is always darkest before the dawn, but I promise you, the dawn is coming. - Harvey Dent"
      "It's not who you are underneath, but what you do that defines you. - Batman"
      "The idea was to be a symbol. Batman... could be anybody. That was the point. - Bruce Wayne"
    ]

    print ($quotes | get (random int 0..(($quotes | length) - 1)))
  '';
in
{
  environment.systemPackages = [ greeting ];
}
