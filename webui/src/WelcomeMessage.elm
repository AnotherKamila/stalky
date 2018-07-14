module WelcomeMessage exposing (..)

import Html                exposing (Html, text)
import Material.Options    as Options exposing (cs, css, div)
import Markdown

msg : String
msg = """Hello world!

You can use Stalky to track anything you want. Enter either a label and a value ("mood 5") or just a label ("the octarine pill").

Stalky will remember recent labels, so you won't have to type them next time. You can also use the slider to enter numbers (convenient on touchscreens).

[OK!](#)"""

view : Html m
view = div [cs "message"] [Markdown.toHtml [] msg]
