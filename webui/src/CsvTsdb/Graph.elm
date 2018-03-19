module CsvTsdb.Graph exposing (..)

import Array
import Date             exposing (Date)
import Date.Extra       as Date
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
import Color.Manipulate exposing (lighten, grayscale)


import CsvTsdb.Model exposing (Record)

type alias Size = { width : Int, height : Int }
type alias Series = { label : String, color : Color, data : List Record }

type alias GraphConfig m =
    { size : Size
    , id : String
    , on_hover : Maybe Record -> m
    , hovered : Maybe Record
    }

make_config : GraphConfig m -> LineChart.Config Record m
make_config conf =
    { x = Axis.custom
        --{ title = AxisTitle.atPosition (\_ range -> (range.min+range.max)/2) 0 30 "Date"
        { title = AxisTitle.atDataMax -10 15 "Date"
        , variable = Just << Date.toTime << .date
        , pixels = conf.size.width
        , range = AxisRange.padded 20 20
        , axisLine = AxisLine.default
        , ticks = AxisTicks.time 5
        }
    , y = Axis.custom
        { title = AxisTitle.default ""
        , variable = Just << .value
        , pixels = conf.size.height
        , range = AxisRange.custom (\datarange -> {min = 0, max = datarange.max+0.5})
        , axisLine = AxisLine.default
        , ticks = AxisTicks.default
        }
    , container = Container.custom
        { attributesHtml = []
        , attributesSvg = []
        , size = Container.relative
        , margin = Container.Margin 30 30 30 30
        , id = conf.id
        }
    , interpolation = Interpolation.monotone
    , intersection = AxisIntersection.default
    , legends = Legends.none
    , events = Events.custom
        [ Events.onMouseMove conf.on_hover Events.getNearest
        , Events.onMouseLeave (conf.on_hover Nothing)
        ]
    , junk = Junk.hoverOne conf.hovered
        [ ( "date", Date.toFormattedString "EEE MMM d, H:mm" << .date )
        , ( "value", toString << .value )
        ]
    , grid = Grid.default
    , area = Area.default
    , line = Line.custom (line_style conf.hovered)
    , dots = Dots.default
    }

line_style : Maybe Record -> List Record -> Line.Style
line_style hovered series =
    case hovered of
        Nothing ->         Line.style 1 identity
        Just r  -> if member r series then Line.style 2 identity else Line.style 1 (lighten 0.2)

view : GraphConfig m -> List Series -> Html m
view conf =
    let wrap_series s = LineChart.line s.color Dots.circle s.label s.data
    in  map wrap_series >>
        LineChart.viewCustom (make_config conf)
