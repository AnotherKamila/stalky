module CsvTsdb.Decode exposing (..)

import Date exposing (Date)
import Result exposing (andThen)
import Result.Extra as Result
import CsvTsdb.Model exposing (Record)

record_from_tuple : (Date, String, Float) -> Record
record_from_tuple (d, s, v) = Record d s v

split_line : String -> Result String (String,String,String)
split_line s = case s |> String.split "," |> List.map String.trim of
    [d, s, v] -> Ok (d,s,v)
    _         -> Err ("Cannot parse CSV: Expected 3 values in '"++s++"'")

parse_date : (String, a, b) -> Result String (Date, a, b)
parse_date (d,s,v) = Date.fromString d |> Result.map (\nd -> (nd, s, v))

parse_value : (a, b, String) -> Result String (a, b, Float)
parse_value (d,s,v) = String.toFloat v |> Result.map (\nv -> (d, s, nv))

unquote_label : (a, String, b) -> (a, String, b)
unquote_label (d,s,v) =
    let ns = if (String.startsWith "\"" s) && (String.endsWith "\"" s)
             then s |> String.dropLeft 1 |> String.dropRight 1
             else s
    in (d, ns, v)

decode_record : String -> Result String Record
decode_record s = split_line s
    |> andThen parse_date
    |> andThen parse_value
    |> Result.map unquote_label
    |> Result.map record_from_tuple

decode_records : String -> Result String (List Record)
decode_records s = s
    |> String.lines
    |> List.filter (not << String.isEmpty)
    |> List.map decode_record
    |> Result.combine
