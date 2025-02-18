with Terminal_Interface.Curses;         use Terminal_Interface.Curses;
with Terminal_Interface.Curses.Text_IO; use Terminal_Interface.Curses.Text_IO;
with Terminal_Interface.Curses.Panels;  use Terminal_Interface.Curses.Panels;
with Terminal_Interface.Curses.Panels.User_Data;

procedure Panel_Browse is
   Number_Of_Lines   : constant Line_Count   := 10;
   Number_Of_Columns : constant Column_Count := 40;

   type Window_Array is array (Positive range <>) of Window;
   My_Windows : Window_Array (1 .. 3);
   My_Panels  : array (1 .. 3) of aliased Panel;

   type Panel_Access is access all Panel;
   package Panel_Data is new Terminal_Interface.Curses.Panels.User_Data
     (Panel, Panel_access);
   use Panel_Data;

   procedure Print_In_Middle
     (Win         : Window := Standard_Window; Start_Y : Line_Position;
      Start_X     : Column_Position; Width : Column_Count; Label : String;
      Label_Color : Color_Pair)
   is
      Y         : Line_Count;
      X         : Column_Count;
      Middle    : Column_Count;
      Old_Color : Color_Pair;
   begin
      Get_Size (Win, Y, X);
      Middle    := (Width - Label'Length) / 2;
      Y         := Start_Y;
      X         := Start_X + Middle;
      Old_Color := Get_Character_Attribute (Win);
      Set_Color (Win, Label_Color);
      Move_Cursor (Win, Y, X);
      Put (Win, Label);
      Set_Color (Win, Old_Color);
      Refresh;
   end Print_In_Middle;

   procedure Window_Show
     (Win : Window; Label : String; Label_Color : Color_Pair)
   is
      Start_Y : Line_Position;
      Start_X : Column_Position;
      Height  : Line_Count;
      Width   : Column_Count;
   begin
      Get_Window_Position (Win, Start_Y, Start_X);
      Get_Size (Win, Height, Width);

      Box (Win);
      Move_Cursor (Win, 2, 0);
      Add (Win, ACS_Map (ACS_Left_Tee));
      Move_Cursor (Win, 2, 1);
      Horizontal_Line
        (Win, Natural (Width - 2), ACS_Map (ACS_Horizontal_Line));
      Move_Cursor (Win, 2, Width - 1);
      Add (Win, ACS_Map (ACS_Right_Tee));

      Print_In_Middle (Win, 1, 0, Width, Label, Label_Color);
   end Window_Show;

   procedure Initialize_Window (Windows : in out Window_Array) is
      Y : Line_Position   := 2;
      X : Column_Position := 10;
   begin
      for I in Windows'Range loop
         Windows (I) := New_Window (Number_Of_lines, Number_Of_Columns, Y, X);
         Window_Show
           (Windows (I), "Window Number" & Integer'Image (I), Color_Pair (I));
         Y := Y + 3;
         X := X + 7;
      end loop;
   end Initialize_Window;

   Top_Panel : Panel_Access;
   Key       : Real_Key_Code;

begin
   -- Initialize curses.
   Init_Screen;
   Start_Color;
   Set_Cbreak_Mode (True);
   Set_Echo_Mode (False);
   Set_Keypad_Mode (SwitchOn => True);

   -- Initialize all the colors.
   Init_Pair (1, Red, Black);
   Init_Pair (2, Green, Black);
   Init_Pair (3, Blue, Black);
   Init_Pair (4, Cyan, Black);

   Initialize_Window (My_Windows);

   -- Attach a panel to each window.  Order is bottom up.
   My_Panels (1) := New_Panel (My_Windows (1)); -- Push 1, order: stdscr-1.
   My_Panels (2) := New_Panel (My_Windows (2)); -- Push 2, order: stdscr-1-2.
   My_Panels (3) := New_Panel (My_Windows (3)); -- Push 3, order: stdscr-1-2-3.

   -- Set up the user pointers to the next panel.
   Set_User_Data (My_Panels (1), My_Panels (2)'Access);
   Set_User_Data (My_Panels (2), My_Panels (3)'Access);
   Set_User_Data (My_Panels (3), My_Panels (1)'Access);

   -- Update the stacking order. Third panel will be on top.
   Update_Panels;

   -- Show it on the screen.
   Set_Color (Pair => 4);
   Move_Cursor (Line => Lines - 2, Column => 0);
   Put ("Use tab to browse through the windows (F1 to Exit)");
   Set_Color (Pair => 0);
   Update_Screen;

   Top_Panel := My_Panels (My_Panels'Last)'Access;
   loop
      Key := Get_Keystroke;   -- Wait for a keystroke, so it can be seen.
      exit when Key = KEY_F1;
      case Key is
         when 9 =>
            Top_Panel := Get_User_Data (Top_Panel.all);
            Top (Top_Panel.all);
         when others =>
            null;
      end case;
      Update_Panels;
      Update_Screen;
   end loop;
   End_Screen;
end Panel_Browse;
