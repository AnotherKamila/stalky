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
import LineChart.Axis as Axis
import LineChart.Axis.Intersection as AxisIntersection
import LineChart.Axis.Range as AxisRange
import LineChart.Axis.Line as AxisLine
import LineChart.Axis.Title as AxisTitle
import LineChart.Axis.Ticks as AxisTicks
import LineChart.Legends as Legends
import LineChart.Line as Line
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Legends as Legends
import LineChart.Colors as Colors
import LineChart.Area as Area
import Color exposing (Color)

import CsvTsdb.Model exposing (Record)

type alias Model = { hovered : Maybe Record }
init_model = { hovered = Nothing }

type alias Size = { width : Int, height : Int }

config : Size -> String -> LineChart.Config Record m
config size id =
    { x = Axis.custom
        --{ title = AxisTitle.atPosition (\_ range -> (range.min+range.max)/2) 0 30 "Date"
        { title = AxisTitle.atDataMax -20 15 "Date"
        , variable = Just << Date.toTime << .date
        , pixels = size.width
        , range = AxisRange.padded 20 20
        , axisLine = AxisLine.default
        , ticks = AxisTicks.time 5
        }
    , y = Axis.custom
        { title = AxisTitle.default ""
        , variable = Just << .value
        , pixels = size.height
        , range = AxisRange.custom (\datarange -> {min = 0, max = datarange.max+0.5})
        , axisLine = AxisLine.default
        , ticks = AxisTicks.default
        }
    , container = Container.custom
        { attributesHtml = []
        , attributesSvg = []
        , size = Container.relative
        , margin = Container.Margin 30 30 30 30
        , id = id
        }
    , interpolation = Interpolation.default
    , intersection = AxisIntersection.default
    , legends = Legends.none
    , events = Events.default
    --, junk = Junk.hoverMany model.hovered formatX formatY
    , junk = Junk.default
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

view : Size -> String -> List Record -> Html m
view size id =
    let wrap_series (label, data) color = LineChart.line color Dots.circle label data
    in records_to_series >>
        map wrap_series >>
        colorize >>
        LineChart.viewCustom (config size id)
