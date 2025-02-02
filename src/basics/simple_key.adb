with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters;

procedure Simple_Key is 
   type Menu_Strings is array (Positive range <>) of String (1..8);
   Choices : constant Menu_Strings := 
     ("Choice 1", "Choice 2", "Choice 3", "Choice 4", "Exit    ");

   procedure Print_Menu (Menu_Win : in Window; Highlight : in out Positive) is 
      Y : Line_Position := 2;
      X : Column_Position := 2;
      Reverse_Attribute : Character_Attribute_Set := (Reverse_video => True, others => False);
   begin
      Box (Menu_Win);
      for I in Choices'Range loop
         Move_Cursor (Menu_Win, Y, X);
         if Highlight = I then
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

   Width : constant := 30;
   Height : constant := 10;
   Start_Y : Line_Position;
   Start_X : Column_Position;
   Menu_Win : Window;
   Highlight : Natural := 1;
   Choice : Natural := 0;
   Key : Real_Key_Code;
   
begin
   Init_Screen;
   Clear;
   Set_Echo_Mode (False);
   Set_Cbreak_Mode;  --  Line buffering disabled.  Pass on everything.
   Start_Y := (Lines - Height) / 2;
   Start_X := (Columns - Width) / 2;

   Menu_Win := Create (Height, Width, Start_Y, Start_X);
   Set_Keypad_Mode (Menu_Win, True);
   Move_Cursor (Line => 0, Column => 0);
   Put ("Use arrow keys to go up and down.  Press enter to select a choice.");
   Refresh;
   Print_Menu (Menu_Win, Highlight);
   loop
      Key := Get_Keystroke (Menu_Win);
      case Key is 
         when Key_UP =>
            if Highlight = 1 then
               Highlight := Choices'Last;
            else
               Highlight := Highlight - 1;
            end if;
         when Key_DOWN =>
            if Highlight = Choices'Last then
               Highlight := 1;
            else
               Highlight := Highlight + 1;
            end if;
         when Key_ENTER | 10 =>
            Choice := Highlight;
         when others =>
            Move_Cursor (Line => Lines - 2, Column => 0);
            Put ("Character pressed has code = " & Real_Key_Code'Image (Key) & " Name " &  Key_Name (Key));
            Refresh;
      end case;
      Print_Menu (Menu_Win, Highlight);
      exit when Choice /= 0;
   end loop;
   Move_Cursor (Line => Lines - 2, Column => 0);
   Put ("You chose choice" & Natural'Image (Choice) & " with choice string """ & 
     Choices(Choice) & """. Press a key to exit.");
   Clear_To_End_Of_Line;
   Refresh;
   Key := Get_Keystroke;
   End_Screen;
end Simple_Key;
