module CsvTsdb.Graph exposing (..)

import Array
import Date
import Time
import List             exposing (..)
import List.Extra       exposing (..)
import Html             exposing (Html)
import Html.Attributes  exposing (class)

--import Svg.Attributes as SvgA
import LineChart
import LineChart.Dots as Dots
import LineChart as LineChart
import LineChart.Junk as Junk exposing (..)
import LineChart.Dots as Dots
import LineChart.Container as Container
import LineChart.Interpolation as Interpolation
import LineChart.Axis.Intersection as Intersection
import LineChart.Axis as Axis
import LineChart.Legends as Legends
import LineChart.Line as Line
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Legends as Legends
import LineChart.Area as Area
import Color exposing (Color)

import CsvTsdb.Model exposing (Record)

type alias Model = { hovered : Maybe Record }
init_model = { hovered : Nothing }

config : LineChart.Config Record m
config =
    { y = Axis.default 450 ""     .value
    , x = Axis.time    700 "date" (.date >> Date.toTime)
    , container =
        -- Try out these different configs!
         Container.responsive "chart-1" -- Try resizing the window!
        --Container.custom
        --    { attributesHtml = []
        --    , attributesSvg = [ SvgA.style "background: #f2fff1;" ]
        --    , size = Container.static
        --    , margin = Container.Margin 20 140 60 80
        --    , id = "line-chart-1"
        --    }
    , interpolation = Interpolation.default
    , intersection = Intersection.default
    , legends = Legends.default
    , events = Events.default
    , junk = Junk.hoverMany model.hinted formatX formatY
    , grid = Grid.default
    , area = Area.default
    , line = Line.default
    , dots = Dots.default
    }

records_to_series : List Record -> List (String, List Record)
records_to_series =
    let grouplabel = map .label >> head >> Maybe.withDefault "whatever" -- always non-empty
        group2series rs = (grouplabel rs, sortBy (.date >> Date.toTime) rs)
    in sortBy .label >> groupWhile (\a b -> a.label == b.label) >> map group2series

colorize : List (Color -> a) -> List a
colorize xs =
    let step = 360.0/(length xs |> toFloat)
        deg2color x = Color.hsl (degrees x) 0.8 0.4
        colors = (range 1 50) |> map (toFloat >> (*)step >> deg2color)
    in map2 (<|) xs colors

--view : List Record -> Html m
--view =
--    let wrap_series (label, data) color = label ++ " " ++ toString color |> Html.text
--    in records_to_series >>
--        map wrap_series >>
--        colorize >>
--        Html.div [ class "csvtsdb-graph" ]


view : List Record -> Html m
view =
    let wrap_series (label, data) color = LineChart.line color Dots.circle label data
    in records_to_series >>
        map wrap_series >>
        colorize >>
        LineChart.viewCustom config >>
        List.singleton >>
        Html.div [ class "csvtsdb-graph" ]
