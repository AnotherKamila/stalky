module CsvTsdb.Api exposing (..)

import Http
import Result exposing (mapError, andThen)

import Config
import CsvTsdb.Model  exposing (Record)
import CsvTsdb.Decode exposing (decode_records)
import Model exposing (Msg(NewData)) -- TODO remove

track_url = Config.api_url ++ "track/"

get_records msg =
    Http.getString track_url
    |> Http.send (mapError toString >> andThen decode_records >> msg)
