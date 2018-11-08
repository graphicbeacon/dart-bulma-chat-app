abstract class View {
  void onEnter(); // Run this when the view is loaded in
  void onExit(); // Run this when we exit the view
  void prepare(); // Prepare the view template, register event handlers etc...
  void render(); // Render the view on the screen
}
