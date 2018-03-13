module Model exposing (Model, Tab(..), Msg(..), init)

import Http
import Material
import Navigation
import CsvTsdb.Model as CsvTsdb exposing (default_record) -- TODO remove exposing
import CsvTsdb.Decode exposing (decode_record) -- TODO remove!

type Tab = Track | View | Explore | NotFound

type alias Model =
    { err           : String
    , tab           : Tab
    , data          : List CsvTsdb.Record
    , data_input    : String
    , slider_input  : Float
    , recent_labels : List String
    -- Boilerplate
    , mdl           : Material.Model -- for Mdl components
    }


type Msg = SelectTab Tab
         | NewData (Result String (List CsvTsdb.Record)) -- TODO change to Http.Error when possible
         | RequestDone (Result Http.Error ())
         | RefreshWanted
         | DataInput String
         | SliderInput Float
         | DataSubmit
         -- Boilerplate
         | Mdl (Material.Msg Msg) -- internal Mdl messages


-- INIT --

init : Model
init =
    { err           = ""
    , tab           = Track
    , data          = []
    , data_input    = ""
    , slider_input  = 5
    , recent_labels = []
    -- Boilerplate
    , mdl           = Material.model
    }
