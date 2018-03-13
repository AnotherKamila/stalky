module Update exposing (update, init)

import Http
import Material
import List.Extra   as List
import Result.Extra as Result

import Model exposing (Model, Msg(..))
import CsvTsdb.Api as CsvTsdb

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SelectTab new -> ({model | tab = new}, Cmd.none)
        NewData r     -> check r update_data Cmd.none model
        RequestDone r -> check r (\_ -> identity) Cmd.none model
        DataInput s   -> ({model | data_input = s}, Cmd.none)
        SliderInput x -> ({model | data_input = add_or_replace_value model.data_input x, slider_input = x}, Cmd.none)
        RefreshWanted -> (model, refresh)
        DataSubmit    -> ({model | data_input = ""}, send_input model.data_input)
        Mdl m         -> Material.update Mdl m model -- Mdl action handler

update_data new model = {model | data = new, recent_labels = find_labels new}
find_labels = List.map .label >> List.unique >> List.take 10 -- Note: recent labels will be a separate query one day

add_or_replace_value : String -> Float -> String
add_or_replace_value s v =
    let ws = String.words s
        should_replace = List.last ws |> Result.fromMaybe "" |> Result.andThen String.toFloat |> Result.isOk
        newws = if should_replace
                then List.init ws |> Maybe.withDefault []
                else ws
    in newws++[toString v] |> String.join " "

check : Result e a -> (a -> Model -> Model) -> Cmd Msg -> Model -> (Model, Cmd Msg)
check result f c model =
    case result of
        Err e -> ({model | err = toString e}, Cmd.none)
        Ok  a -> (f a model, c)

-- COMMANDS --

send_input : String -> Cmd Msg
send_input = CsvTsdb.send_input >> Http.send RequestDone

refresh : Cmd Msg
refresh = CsvTsdb.get_records NewData

-- INIT --

init : Cmd Msg
init = refresh
