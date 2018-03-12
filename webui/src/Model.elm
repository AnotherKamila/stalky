module Model exposing (Model, Tab(..), Msg(..), init)

import Material
import Navigation
import CsvTsdb.Model as CsvTsdb exposing (default_record) -- TODO remove exposing
import CsvTsdb.Decode exposing (decode_record) -- TODO remove!

type Tab = Track | View | Explore | NotFound

type alias Model =
    { err      : String
    , tab      : Tab
    , data     : List CsvTsdb.Record
    -- Boilerplate
    , mdl      : Material.Model -- for Mdl components
    }


type Msg = SelectTab Tab
         | NewData (Result String (List CsvTsdb.Record))
         | RefreshWanted
         -- Boilerplate
         | Mdl (Material.Msg Msg) -- internal Mdl messages


-- INIT --

init : Model
init =
    { err      = ""
    , tab      = Track
    , data     = []
    -- Boilerplate
    , mdl      = Material.model
    }
