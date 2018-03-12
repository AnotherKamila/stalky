module CsvTsdb.TrackView exposing (..)

import Date.Extra         as Date
import Html               exposing (Html, text)
import Material.Card      as Card
import Material.Color     as Color
import Material.Elevation as Elevation
import Material.Table     as Table
import Material.Options   exposing (cs, css, div)

import CsvTsdb.Model exposing (Record)

view : List Record -> Html msg
view records = [input, recents records] |> div [ cs "track-container" ]

input : Html msg
input = Card.view
    [ cs "full-width"
    , Color.background (Color.color Color.Indigo Color.S50)
    , Elevation.e2
    ]
    [ Card.text [] [ text "blah" ]
    ]

recents : List Record -> Html msg
recents records = Table.table
    [ cs "full-width", Elevation.e2 ]
    [ Table.tbody []
        (records |> List.map (\record ->
            Table.tr []
                [ Table.td [] [ text (view_date record.date) ]
                , Table.td [] [ text record.label ]
                , Table.td [ Table.numeric ] [ text (toString record.value) ]
                ]
            )
        )
    ]

view_date = Date.toFormattedString "EEE MMM d, h:mm a"
