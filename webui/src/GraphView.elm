module GraphView exposing (..)

import List                exposing (..)
import List.Extra as List  exposing (..)
import Date
import Material.Color      as Color -- TODO maybe not
import Html                exposing (Html, text)
import Material.Chip       as Chip
import Material.Options    as Options exposing (cs, css, div, span)
import Material.Typography as Typo
import Color               exposing (Color)
import Color.Convert       exposing (colorToCssRgb)
import Color.Manipulate    exposing (lighten)

import Model exposing (Msg(..))
import CsvTsdb.Graph
import CsvTsdb.Model exposing (Record)

label_chip is_selected s = Chip.button
    [ css "background-color" (s.color |> lighten (if is_selected then 0.2 else 0.4) |> colorToCssRgb)
    , Options.onClick (SeriesToggled s.label)
    ]
    [ Chip.content [] [ text s.label ] ]

view model =
    let series = model.data |> records_to_series
        selected_series = series |> filter (\s -> member s.label model.selected_series)
        labels_html = series |> List.map (\s -> label_chip (member s.label model.selected_series) s)
        labels_title = div [ Typo.subhead ] [ text "Select series to display:" ]
        graph_config =
            { id ="view-chart-chart"
            , size = { width = model.window_size.width, height = model.window_size.height - 100 }
            , on_hover = Hovered
            , hovered = model.hovered_point
            }
    in  [ (labels_title :: labels_html) |> div [ cs "view-chart-select-series"]
        , CsvTsdb.Graph.view graph_config selected_series
        ] |> div [ cs "view-chart" ]

groupBy : (a -> b) -> List a -> List (List a)
groupBy f = groupWhile (\a b -> f a == f b)

colorize : List (Color -> a) -> List a
colorize xs =
    let step = 360.0/(length xs |> toFloat)
        deg2color x = Color.hsl (degrees x) 0.8 0.5
        colors = (range 1 50) |> map (toFloat >> (*)step >> deg2color)
    in map2 (<|) xs colors

records_to_series : List Record -> List CsvTsdb.Graph.Series
records_to_series =
    let
        group2series rs color = { label = grouplabel rs, color = color, data = sortBy (.date >> Date.toTime) rs }
        grouplabel = map .label >> head >> Maybe.withDefault "whatever" -- always non-empty
    in sortBy .label >> groupBy .label >> map group2series >> colorize

