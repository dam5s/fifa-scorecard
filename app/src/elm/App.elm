module App exposing (main)

import Browser
import Html exposing (Html, dd, div, dl, dt, h1, h2, section, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias Flags =
    {}


type alias Team =
    { name : String
    , goals : Int
    , redCards : Int
    , goalsByGoalkeeper : Int
    , redCardsByGoalkeeper : Int
    , refereeWarnings : Int
    }


initTeam : String -> Team
initTeam name =
    { name = name
    , goals = 0
    , redCards = 0
    , goalsByGoalkeeper = 0
    , redCardsByGoalkeeper = 0
    , refereeWarnings = 0
    }


type alias Model =
    { teamA : Team
    , teamB : Team
    }


type Msg
    = UpdateTeamA (Team -> Team)
    | UpdateTeamB (Team -> Team)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { teamA = initTeam "Team A"
      , teamB = initTeam "Team B"
      }
    , Cmd.none
    )


lineItem : String -> Int -> Msg -> Html Msg
lineItem label count msg =
    dl [ onClick msg ]
        [ dd [] [ text <| String.fromInt count ]
        , dt [] [ text label ]
        ]


addGoal team =
    { team | goals = team.goals + 1 }


addRedCard team =
    { team | redCards = team.redCards + 1 }


addGoalByGoalkeeper team =
    { team | goalsByGoalkeeper = team.goalsByGoalkeeper + 1 }


addRedCardByGoalkeeper team =
    { team | redCardsByGoalkeeper = team.redCardsByGoalkeeper + 1 }


addRefereeWarning team =
    { team | refereeWarnings = team.refereeWarnings + 1 }


teamControls : Team -> ((Team -> Team) -> Msg) -> Html Msg
teamControls team updateMsg =
    div [ class "controls" ]
        [ lineItem "Goals" team.goals (updateMsg addGoal)
        , lineItem "Red cards" team.redCards (updateMsg addRedCard)
        , lineItem "Goals by goalkeeper" team.goalsByGoalkeeper (updateMsg addGoalByGoalkeeper)
        , lineItem "Red cards by goalkeeper" team.redCardsByGoalkeeper (updateMsg addRedCardByGoalkeeper)
        , lineItem "Referee warnings" team.refereeWarnings (updateMsg addRefereeWarning)
        ]


score : Team -> Int
score team =
    team.goals + team.redCards + team.goalsByGoalkeeper * 2 + team.redCardsByGoalkeeper * 2 - team.refereeWarnings


teamScore : Team -> Html Msg
teamScore team =
    dl [ class "score" ]
        [ dd [] [ text team.name ]
        , dt [] [ text <| String.fromInt (score team) ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "FIFA Scorecard" ]
        , section []
            [ teamControls model.teamA UpdateTeamA
            , teamScore model.teamA
            , teamScore model.teamB
            , teamControls model.teamB UpdateTeamB
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTeamA function ->
            ( { model | teamA = function model.teamA }, Cmd.none )

        UpdateTeamB function ->
            ( { model | teamB = function model.teamB }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
