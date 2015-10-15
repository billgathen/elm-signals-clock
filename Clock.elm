-- Clock.elm
--
-- http://elm-lang.org
--
-- This is a heavily-annotated example app for using signals in Elm
-- to create an in-browser clock. For a clearer view of the code,
-- feel free to delete all the comments! :)
--
-- A signal is a value that can change over time as a result of some
-- occurrence in the environment, unlike normal values which need to be
-- change explicitly by the program. They are similar to event streams in
-- other languages.
--
-- First, define a module that matches the name of the file.
--
module Clock where

-- Now pull in all the libraries you'll need.
-- The "exposing (..)" convention adds the function to the namespace
-- so you don't need to preface them with the module name.
--
import Html exposing (..)
import Time
import Date
import String

-- Create a signal. The Time module has a .every function which is a
-- signal that will update to the current time after a specified interval.
-- Our clock should update every second, so we use the .second
-- function in the Time module to describe the interval.
--
-- As the function declaration indicates (the "tick : Signal Time.Time" line),
-- the function returns a signal of Time constructs that indicate the current time.
--
tick : Signal Time.Time
tick =
  Time.every Time.second

-- But we don't want the raw timestamp, we want the standard hh:mm:ss format.
-- Let's create an asClock helper function for converting a single Time value
-- into the string we'll want to output.
--
asClock : Time.Time -> String
asClock t =
  let
    d = Date.fromTime t
    h = Date.hour(d)   |> toString |> twoPlaces
    m = Date.minute(d) |> toString |> twoPlaces
    s = Date.second(d) |> toString |> twoPlaces
  in
    h ++ ":" ++ m ++ ":" ++ s

-- To make sure we don't get times like 7:1:1 when we want 07:01:01, we'll add
-- another helper method to make that easy.
--
twoPlaces : String -> String
twoPlaces s =
  if (String.length s) < 2 then twoPlaces ("0" ++ s) else s

-- Now we'll blend these three functions into a signal of strings in the hh:mm:ss format.
--
-- To do that, we'll use Signal.map to apply the asClock helper to each
-- value that comes out of the tick function. Notice that this is exactly how we usually
-- apply a map function to a list of values in an array, but with signals the values are
-- spread out over time and we do the transformation as they arrive instead of all at once
-- at the beginning.
--
clock : Signal String
clock =
  Signal.map asClock tick

-- All that remains is to pipe these values into our main function, which is what Elm
-- executes when the page loads.
--
-- We'll use another Signal.map to take the signal of strings and wrap them in the
-- .text function from the Html module. This returns a signal of HTML elements which
-- the main function will use to re-render the page every time the clock signal changes.
--
main : Signal Html
main =
  Signal.map text clock

-- We've written our app, but it expects the Html module to be available. Lets install
-- the package that includes that module using the built-in package installer.
--
-- Run the following at the command-line in the same directory as this file:
--
--   elm package install evancz/elm-html
--
-- Answer yes to all the questions the installer asks you. It will add an elm-stuff
-- directory with the elm-html package inside it, giving our app access to all those functions.
--
--
-- We're done! To generate a standalone webpage with the output of this module as the
-- only content, run the following at the command-line:
--
--   elm make Clock.elm --output index.html
--
-- ...then open index.html in your browser. Ta-da! You'll never be late to a meeting again.
--
-- For details on how to embed this as a live widget in a pre-built page, check out:
--   http://elm-lang.org/guide/interop#html-embedding
--
