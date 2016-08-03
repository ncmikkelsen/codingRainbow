class Painter {
  int x;
  int y;
  int w;
  int h;
  int r;
  int g;
  int b;
  int a;

  Painter(int _w, int _h) {
    x = (int) random(width);
    y = (int) random(height);
    w = _w;
    h = _h;
    r = (int) random(256);
    g = (int) random(256);
    b = (int) random(256);
    a = (int) random(256);
  }
  Painter (int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    r = (int) random(256);
    g = (int) random(256);
    b = (int) random(256);
    a = (int) random(256);
  }

  Painter() {
    w = (int) random(random(300));
    h = w;

    x = (int) random(width);
    y = (int) random(height);

    r = (int) random(256);
    g = (int) random(256);
    b = (int) random(256);
    a = (int) random(256);
  }

  void show() {
    noStroke();
    fill(r, g, b, a);
    ellipse(x, y, w, h);
  }
}