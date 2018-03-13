module CsvTsdb.Graph exposing (..)

import Date
import Time
import List             exposing (..)
import List.Extra       exposing (..)
import Html             exposing (Html)
import Html.Attributes  exposing (class)
import Charty.LineChart as LineChart exposing (Dataset)
import Charty.Color

import CsvTsdb.Model exposing (Record)

config = { drawPoints      = True
         , background      = "white"
         , colorAssignment = Charty.Color.assignDefaults
         , labelPrecision  = 0
         , drawLabels      = True
         }

records_to_dataset : List Record -> Dataset
records_to_dataset =
    let
        grouplabel : List Record -> String
        grouplabel = map .label >> head >> Maybe.withDefault "whatever" -- always non-empty
        record2datapoint : Record -> LineChart.DataPoint
        record2datapoint r = (r.date |> Date.toTime |> Time.inSeconds, r.value)
        group2series : List Record -> LineChart.Series
        group2series rs = { label = grouplabel rs, data = map record2datapoint rs }
    in sortBy .label >> groupWhile (\a b -> a.label == b.label) >> map group2series

view : List Record -> Html m
view = records_to_dataset >>
    LineChart.view config >>
    List.singleton >>
    Html.div [ class "csvtsdb-graph" ]

