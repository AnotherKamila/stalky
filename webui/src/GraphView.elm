module GraphView exposing (..)

import List.Extra          as List
import Material.Color      as Color -- TODO maybe not
import Html                exposing (Html, text)
import Material.Chip       as Chip
import Material.Options    as Options exposing (cs, css, div, span)
import Material.Typography as Typo


import CsvTsdb.Graph

-- TODO behavior / onClick
label_chip t = Chip.button
    [ Color.background (Color.color Color.Green Color.S100) ]
    [ Chip.content [] [ text t ] ]

view model =
    let labels = model.data |> List.map .label |> List.unique |> List.sort
        labels_html = labels |> List.map label_chip
        labels_title = div [ Typo.subhead ] [ text "Select series to display:" ]
    in  [ (labels_title :: labels_html) |> div [ cs "view-chart-select-series"]
        , CsvTsdb.Graph.view { width = 700, height = 400 } "view-chart-chart" model.data
        ] |> div [ cs "view-chart" ]
