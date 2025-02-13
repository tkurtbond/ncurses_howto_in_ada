with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Mouse;   use Terminal_Interface.Curses.Mouse;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Ada.Strings;                       use Ada.Strings;
with Ada.Strings.Fixed;                 use Ada.Strings.Fixed;
procedure Mouse_Menu is

   type Menu_Strings is array (Positive range <>) of String (1..8);
   Choices : constant Menu_Strings :=
     ("Choice 1", "Choice 2", "Choice 3", "Choice 4", "Exit    ");
   Exit_Choice : constant Positive := Choices'Last;

   Reverse_Attribute : Character_Attribute_Set :=
     (Reverse_video => True, others => False);

   Start_Y : Line_Position;
   Start_X : Column_Position;

   procedure Print_Menu (Menu_Win : in Window; Highlight : in Natural) is
      Y : Line_Position := 2;
      X : Column_Position := 2;
   begin
      Box (Menu_Win);
      for I in Choices'Range loop
         Move_Cursor (Menu_Win, Y, X);
         if Highlight in Choices'Range and Highlight = I then
            Switch_Character_Attribute (Menu_Win, Reverse_Attribute, True);
            Put (Menu_Win, Choices(I));
            Switch_Character_Attribute (Menu_Win, Reverse_Attribute, False);
         else
            Put (Menu_Win, Choices(I));
         end if;
         Y := Y + 1;
      end loop;
      Refresh (Menu_Win);
   end Print_Menu;
   
   -- Report the choice according to mouse position.
   procedure Report_Choice (Mouse_Y : Line_Position;
                            Mouse_X : Column_Position;
                            Choice : out Natural) is
      J : Line_Position := Start_Y + 1;
      I : Column_Position := Start_X + 2;
   begin
      for C in Choices'Range loop
         if Mouse_Y = J + Line_Position (C) and 
           -- On the right line?
           Mouse_X >= I and Mouse_X <= I + Trim (Choices(C), Both)'Length - 1
           -- In right columns?
         then
            Choice := C;
            exit;
         end if;
      end loop;
   end Report_Choice;

   Width : constant := 30;
   Height : constant := 10;

   Menu_Win : Window;
   Choice : Natural := 1;

   Old_Event_Mask : Event_Mask;
   Key : Real_Key_Code;

begin
   Init_Screen;                         -- Initialize curses.
   Clear;
   Set_Echo_Mode (False);
   Set_Cbreak_Mode;   -- Line buffering disabled.  Pass on everything.

   -- Put the window in the middle of the screen.
   Start_Y := (Lines - Height) / 2;
   Start_X := (Columns - Width) / 2;

   Switch_Character_Attribute (Standard_Window, Reverse_Attribute, True);
   Move_Cursor (Line => Lines - 2, Column => 1);
   Put ("Click on Exit to quit (Works best in a virtual console)");
   Switch_Character_Attribute (Standard_Window, Reverse_Attribute, False);

   Menu_Win := Create (Height, Width, Start_Y, Start_X);
   Print_Menu (Menu_Win, 0);    -- Print the menu for the first time.

   -- This gets mouse clicks reported in Menu_Win, even on terminal emulators,
   -- as well as on the Linux console.
   Set_Keypad_Mode (Menu_Win);

   -- Get all the mouse events.
   Old_Event_Mask := Start_Mouse;

   loop
      Key := Get_Keystroke (Menu_Win);
      case Key is
         when Key_MOUSE =>
            declare
               Event : Mouse_Event := Get_Mouse;
               Y : Line_Position;
               X : Column_Position;
               Button : Mouse_Button;
               State : Button_State;
            begin
               Get_Event (Event, Y, X, Button, State);
               if Button = Left and State = Pressed then
                  -- When the user clicks the left mouse button.
                  Report_Choice (Y, X, Choice);
                  exit when Choice = Exit_Choice;
                  Move_Cursor (Line => Lines - 2, Column => 1);
                  if Choice not in Choices'Range then 
                     Put ("Mouse was not clicked on a menu entry.");
                  else
                     Put ("Choice made is" & Natural'Image (Choice) &
                       ".  String chosen is """ & 
                       Trim (Choices (Choice), Both) & """.");
                  end if;
                  Clear_To_End_Of_Line;
                  Refresh;
               end if;
            end;
            Print_Menu (Menu_Win, Choice);
         when others =>
            null;
      end case;
   end loop;
   Move_Cursor (Line => Lines - 2, Column => 1);
   Put ("You chose choice" & Natural'Image (Choice) & " with choice string """ &
     Trim (Choices(Choice), Both) & """.");
   Clear_To_End_Of_Line;
   Refresh;
   End_Screen;
end Mouse_Menu;
