module Pages.Image exposing (view, Msg, update, init, Model)

import Html exposing (Html, h1, map, text, div, span)
import Html.Attributes exposing (class)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)

import Header
import Footer

init : Int -> ( Model, Cmd Msg )
init id =
    ( { header = Header.init
      , footer = Footer.init
      , imageId = id
      , imageData = Nothing
      , error = Nothing
      }, Cmd.none )

type alias Model =
    { 
        header: Header.Model
        , footer: Footer.Model
        , imageId: Int
        , imageData: Maybe Image
        , error: Maybe String
    }

type alias Image =
    {
        id : Int
        , name : String
        , description : String
        , url : String
        , tags : List String
        , createdAt : String
        , updatedAt : String
    }

type Msg 
    = HeaderMsg Header.Msg
    | FooterMsg Footer.Msg
    | GetTheImage
    | GotItem (Result Http.Error (Image))

getImage : Model -> Cmd Msg
getImage model = 
    let
        urlToCall = "http://localhost:8080/images/" ++ String.fromInt model.imageId
    in  
        Http.get
        { url = urlToCall
        , expect = Http.expectJson GotItem decodeImage
        }

decodeImage : Decoder Image
decodeImage =
    Decode.map7 Image
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "tags" (Decode.list Decode.string))
        (Decode.field "createdAt" Decode.string)
        (Decode.field "updatedAt" Decode.string)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
    HeaderMsg headerMsg ->
      ( { model | header = Header.update headerMsg model.header }, Cmd.none )

    FooterMsg footerMsg ->
      ( { model | footer = Footer.update footerMsg model.footer }, Cmd.none )

    GetTheImage ->
        (model, getImage model)

    GotItem (Ok image) ->
        ( { model | error = Nothing, imageData = Just image }, Cmd.none )

    GotItem (Err err) ->
        ( { model | error = Just <| errorToString err, imageData = Nothing }, Cmd.none )

errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "Bad url: " ++ url

        Timeout ->
            "Request timed out."

        NetworkError ->
            "Network error. Are you online?"

        BadStatus status_code ->
            "HTTP error " ++ String.fromInt status_code

        BadBody body ->
            "Unable to parse response body: " ++ body

view : Model -> Html Msg
view model =
    div []
    [   
        map HeaderMsg (Header.view model.header)
        , div[class "content"]
        [
            div []
                [ 
                    h1 [] [ text "Page de l'image"],
                    span [] [text (String.fromInt model.imageId)]
                ]
        ]
        , map FooterMsg (Footer.view model.footer)
    ]