module Update exposing (update, init)

import Material
import List.Extra   as List
import Result.Extra as Result

import Model exposing (Model, Msg(..))
import CsvTsdb.Api as CsvTsdb

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- TODO handle errors :D
        SelectTab new    -> ({model | tab = new}, Cmd.none)
        NewData (Ok new) -> ({model | data = new, recent_labels = find_labels new}, Cmd.none) -- TODO this will be a separate query one day
        NewData (Err e)  -> ({model | err = e},   Cmd.none)
        DataInput s      -> ({model | data_input = s}, Cmd.none)
        SliderInput x    -> ({model | data_input = add_or_replace_value model.data_input x, slider_input = x}, Cmd.none)
        RefreshWanted    -> (model, refresh)
        Mdl m            -> Material.update Mdl m model -- Mdl action handler

find_labels = List.map .label >> List.unique

add_or_replace_value : String -> Float -> String
add_or_replace_value s v =
    let ws = String.words s
        should_replace = List.last ws |> Result.fromMaybe "" |> Result.andThen String.toFloat |> Result.isOk
        newws = if should_replace
                then List.init ws |> Maybe.withDefault []
                else ws
    in newws++[toString v] |> String.join " "

-- COMMANDS --

refresh : Cmd Msg
refresh = CsvTsdb.get_records NewData

-- INIT --

init : Cmd Msg
init = refresh
