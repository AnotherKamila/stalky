module Update exposing (update, init)

import Material

import Model exposing (Model, Msg(..))
import CsvTsdb.Api as CsvTsdb

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- TODO handle errors :D
        SelectTab new    -> ({model | tab = new},  Cmd.none)
        NewData (Ok new) -> ({model | data = new}, Cmd.none)
        NewData (Err e)  -> ({model | err = e},    Cmd.none)
        RefreshWanted    -> (model, refresh)
        Mdl m            -> Material.update Mdl m model -- Mdl action handler

-- COMMANDS --

refresh : Cmd Msg
refresh = CsvTsdb.get_records NewData

-- INIT --

init : Cmd Msg
init = refresh
