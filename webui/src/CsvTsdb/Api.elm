module CsvTsdb.Api exposing (..)

import Http
import Json.Decode          as Decode
import Json.Decode.Pipeline as Decode
import Result exposing (mapError, andThen)

import Config
import CsvTsdb.Model  exposing (Record)
import CsvTsdb.Decode exposing (decode_records)
import Model exposing (Msg(NewData)) -- TODO remove

track_url = Config.api_url ++ "track/"

decode_error : Decode.Decoder String
decode_error = Decode.decode
    (\s -> if String.isEmpty s then Decode.succeed "42" else Decode.fail s)
    |> Decode.optional "error" (Decode.string) ""
    |> Decode.resolve

get_records msg =
    Http.getString track_url
    |> Http.send (mapError toString >> andThen decode_records >> msg)

send_input : String -> Http.Request String
send_input input =
    Http.post track_url (Http.stringBody "text/plain" input) decode_error
