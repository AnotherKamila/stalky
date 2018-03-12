module CsvTsdb.Model exposing (..)

import Date exposing (Date, Month(Jan))
import Date.Extra as Date

type alias Record = { date : Date, label : String, value : Float }
--type alias Record = { date : String, label : String, value : String }

default_record = { date  = Date.fromCalendarDate 1970 Jan 1
                 , label = "If you see this, something is wrong"
                 , value = 47
                 }
