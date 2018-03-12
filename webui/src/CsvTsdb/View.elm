module CsvTsdb.View exposing (..)

import Html exposing (Html, text)

import CsvTsdb.Model exposing (Record)

view_record : Record -> Html msg
view_record r = (toString r.date)++","++r.label++","++(toString r.value) |> text

track : List Record -> Html msg
track rs = List.map view_record rs |> Html.div []
