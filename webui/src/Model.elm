module Model exposing (Model, Tab(..), Msg(..), init)

import Http
import Material
import Navigation
import Window
import CsvTsdb.Model as CsvTsdb

type Tab = Track | View | Explore | NotFound

type alias Model =
    { err             : String
    , tab             : Tab
    , data            : List CsvTsdb.Record
    , recent_labels   : List String
    , data_input      : String
    , slider_input    : Float
    , selected_series : List String
    , hovered_point   : Maybe CsvTsdb.Record
    , window_size     : Window.Size
    -- Boilerplate
    , mdl             : Material.Model -- for Mdl components
    }


type Msg = SelectTab Tab
         | NewData (Result String (List CsvTsdb.Record)) -- TODO change to Http.Error when possible
         | RequestDone (Result Http.Error ())
         | RefreshWanted
         | DataInput String
         | SliderInput Float
         | DataSubmit
         | Hovered (Maybe CsvTsdb.Record)
         | SeriesToggled String
         | WindowResize Window.Size
         -- Boilerplate
         | Mdl (Material.Msg Msg) -- internal Mdl messages


-- INIT --

init : Model
init =
    { err             = ""
    , tab             = Track
    , data            = []
    , recent_labels   = []
    , data_input      = ""
    , slider_input    = 5
    , selected_series = []
    , hovered_point   = Nothing
    -- Boilerplate
    , mdl             = Material.model
    , window_size     = {height = 400, width = 700}
    }
