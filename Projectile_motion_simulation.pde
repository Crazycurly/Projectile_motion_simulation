import processing.awt.PSurfaceAWT;
import processing.awt.PSurfaceAWT.SmoothCanvas;
import processing.core.PApplet;
import processing.core.PImage;
import processing.serial.Serial;
import java.awt.*;
boolean run = false;
    boolean line = true;
    ControlFrame cf;
    Serial serial_port = null;
    PImage[] img = new PImage[19];
    PImage back, grass, gun, tree, auth;
    boolean click = true;
    boolean continued = false;
    int conum = 0;
    int i = 0;
    int deg = 29;
    float x2 = 950, h2 = 670, h1 = 135;
    int w = 180;
    double Deg = 29.0;
    double g = 9.8;
    float v = 150;
    float speed = 1;
    float x = w;
    float y = h1;
    float y2 = h2;
    float timer = 0;
    int tmp = 0;
    boolean play = false;
    boolean show = false;
    boolean move = false;
    boolean limit = false;
    button monkey, play_b, pause, stop, dp, dm, tp, tm, gp, gm, vp, vm, tr, gr, vr, fast, rewind, blue,change;
     public void settings() {
        //cf = new ControlFrame(this, 300, 150, "cf name");
        size(1280, 720);
        auth = loadImage("auth.png");
        back = loadImage("back.jpg");
        grass = loadImage("grass.png");
        tree = loadImage("tree.png");
        gun = loadImage("gun.png");
        img[0] = loadImage("monkey.png");
        img[1] = loadImage("play.png");
        img[2] = loadImage("pause.png");
        img[3] = loadImage("stop.png");
        img[4] = loadImage("up.png");
        img[5] = loadImage("down.png");
        img[6] = loadImage("plus.png");
        img[7] = loadImage("minus.png");
        img[8] = loadImage("plus.png");
        img[9] = loadImage("minus.png");
        img[10] = loadImage("plus.png");
        img[11] = loadImage("minus.png");
        img[12] = loadImage("replay.png");
        img[13] = loadImage("replay.png");
        img[14] = loadImage("replay.png");
        img[15] = loadImage("fast.png");
        img[16] = loadImage("rewind.png");
        img[17] = loadImage("bluetooth.png");
        img[18]=loadImage("line.png");
        monkey = new button(img[0], 950, 60, 10);
        play_b = new button(img[1], 20, 40);
        pause = new button(img[2], 110, 40);
        stop = new button(img[3], 200, 40);
        dp = new button(img[4], 20, 400);
        dm = new button(img[5], 20, 530);
        tp = new button(img[6], 195, 115, 45);
        tm = new button(img[7], 85, 115, 45);
        gp = new button(img[8], 195, 155, 45);
        gm = new button(img[9], 85, 155, 45);
        vp = new button(img[10], 195, 195, 45);
        vm = new button(img[11], 85, 195, 45);
        tr = new button(img[12], 230, 115, 45);
        gr = new button(img[13], 230, 155, 45);
        vr = new button(img[14], 230, 195, 45);
        fast = new button(img[15], 470, 40);
        rewind = new button(img[16], 290, 40);
        blue = new button(img[17], 560, 40);
        change=new button(img[18],650,40);
        //myPort = new Serial(this, "COM4", 115200);
        tmp = millis();
    }

    public void setup() {
        background(auth);
    }

    public void draw() {
        if (!run) {
            if (mousePressed) {
                delay(100);
                run = true;
            }

            return;
        }
        if (serial_port != null) {
            if (serial_port.available() > 0) {
                char inByte = serial_port.readChar();
                if (inByte == 'f') {
                    byte[] inData = new byte[4];
                    serial_port.readBytes(inData);
                    int intbit = 0;
                    intbit = (inData[3] << 24) | ((inData[2] & 0xff) << 16) | ((inData[1] & 0xff) << 8) | (inData[0] & 0xff);
                    if (!play && timer == 0)
                        Deg = Float.intBitsToFloat(intbit);
                } else if (inByte == 'H') {
                    if (limit)
                        show = true;
                    else
                        play = true;
                }
            }
        }

        background(back);
        fill(0);
        image(grass, 0, 650, 1280, 100);
        image(tree, 950, 20, 500, 200);

        if (timer == 0)
            limit = false;
        if (play_b.display() || play) {
            if ((millis() - tmp) > 1) {
                tmp = millis();
                timer += 0.1 * speed;
                play = true;
            }
        }
        if (blue.display())
            cf = new ControlFrame(this, 300, 150, "cf name");

        if (monkey.display() && !play)
            move = !move;

        if (move) {
            int bs = width / 10;
            monkey.coordinateX(mouseX - bs / 2);
            monkey.coordinateY(mouseY - bs / 2);
            h2 = 720 - (mouseY - bs / 2);
        }

        if (pause.display())
            play = false;

        if (stop.display() || show) {
            play = false;
            if (timer > 0) {
                timer -= 0.1;
                show = true;
            } else {
                timer = 0;
                show = false;
            }
        }

        if (dp.display() && !play)
            Deg += 1;

        if (dm.display() && !play)
            Deg -= 1;


        if (tp.display() && !play)
            timer += 0.1;
        if (tm.display() && !play)
            timer -= 0.1;
        if (gp.display() && !play)
            g += 0.1;
        if (gm.display() && !play)
            g -= 0.1;
        if (vp.display() && !play)
            v += 1;
        if (vm.display() && !play)
            v -= 1;
        if (tr.display() && !play)
            timer = 0;
        if (gr.display() && !play)
            g = 9.8;
        if (vr.display() && !play)
            v = 150;
        if (fast.display() && !play)
            speed *= 2;
        if (rewind.display() && !play)
            speed /= 2;
        if(change.display()){
            line=!line;
        }

        y = (float) (h1 + v * timer * sin(radians((float) Deg)) - 0.5 * g * sq(timer));
        x = w + v * timer * cos(radians((float) Deg));
        ellipse(x, cy((int) y), 10, 10);
        if (line)
            dline(w, h1, 1280, (1280 - w) * tan(radians((float) Deg)) + h1);
        else
            parabola();

        y2 = (float) (h2 - 0.5 * g * sq(timer));
        if (y2 <= 70) {
            play = false;
            limit = true;
        }
        if ((x - (monkey.px() + 64)) >= 0) {
            play = false;
            limit = true;
        }
        monkey.coordinateY((int) (720 - y2));

        textSize(32);
        text(nf(speed, 0, 2), 376, 82);
        text((int) Deg, 35, 510);
        text("T=", 35, 140);
        text(nf((float) (timer / 10.0), 0, 2), 120, 140);
        text("g=", 35, 180);
        text(nf((float) g, 0, 1), 120, 180);
        text("v=", 35, 220);
        text(nf((v / 10), 0, 1), 120, 220);
        text("Y1=", 18, 260);
        text(nf((y / 100), 0, 2), 120, 260);
        text("Y2=", 18, 300);
        text(nf(((y2 - 64) / 100), 0, 2), 120, 300);

        pushMatrix();
        imageMode(CENTER);
        translate(180, 585);
        rotate(radians(-(float) (Deg)));
        image(gun, 0, 0, 161, 66);
        imageMode(CORNER);
        popMatrix();

        monkey.display();

        if (continued)
            conum++;
        if (conum > 30)
            click = true;
    }

    void parabola() {
        float Yt, Xt;
        for (float i = 0; i < 20; i += 0.1) {
            Yt = (float) (h1 + v * i * sin(radians((float) Deg)) - 0.5 * g * sq(i));
            Xt = w + v * i * cos(radians((float) Deg));
            ellipse(Xt, cy((int) Yt), 3, 3);
        }
    }

    void dline(int x1, float y1, int x2, float y2) {

        float d = atan2(y2 - y1, x2 - x1);
        float X, Y;
        int dis = (int) sqrt(sq(x2 - x1) + sq(y2 - y1));
        for (int i = 0; i < dis; i += 10) {
            X = i * cos(d) + x1;
            Y = i * sin(d) + y1;
            if (X > monkey.px() + monkey.width() / 15 || Y < 10)
                break;
            ellipse(X, cy((int) Y), 3, 3);
        }

    }

    int cy(int y) {
        return (int) map(y, 0, 720, 720, 0);
    }

    public void mouseReleased() {
        click = true;
        continued = false;
        conum = 0;
    }

    public void mousePressed() {
        continued = true;
    }

    class button {
        PImage img;
        int x, y, w, h;

        button(PImage img, int x, int y) {
            this.img = img;
            this.x = x;
            this.y = y;
            w = width / 20;
            h = width / 20;
        }

        button(PImage img, int x, int y, int size) {
            this.img = img;
            this.x = x;
            this.y = y;
            w = width / size;
            h = width / size;
        }

        void coordinateX(int x) {
            this.x = x;
        }

        void coordinateY(int y) {
            this.y = y;
        }

        int px() {
            return x;
        }

        int py() {
            return y;
        }

        int width() {
            return width;
        }

        int height() {
            return height;
        }

        boolean state() {
            return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
        }

        boolean display() {
            boolean push = false;
            if (state()) {
                tint(128, 128, 128);
                if (mousePressed && (mouseButton == LEFT) && click) {
                    push = true;
                    click = false;
                }
            } else
                noTint();
            image(img, x, y, w, h);
            noTint();
            return push;
        }
    }

    class ControlFrame extends PApplet {
        int w, h;
        PApplet parent;
        Button btn_serial_up;              // move up through the serial port list
        Button btn_serial_dn;              // move down through the serial port list
        Button btn_serial_connect;         // connect to the selected serial port
        Button btn_serial_disconnect;      // disconnect from the serial port
        Button btn_serial_list_refresh;    // refresh the serial port list
        Button close;
        String serial_list;                // list of serial ports
        int serial_list_index = 0;         // currently selected serial port
        int num_serial_ports = 0;          // number of serial ports in the list

        public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
            super();
            parent = _parent;
            w = _w;
            h = _h;
            PApplet.runSketch(new String[]{this.getClass().getName()}, this);

        }

        public void settings() {
            size(w, h);

            // create the buttons
            btn_serial_up = new Button("^", 140, 10, 40, 20);
            btn_serial_dn = new Button("v", 140, 50, 40, 20);
            btn_serial_connect = new Button("Connect", 190, 10, 100, 25);
            btn_serial_disconnect = new Button("Disconnect", 190, 45, 100, 25);
            btn_serial_list_refresh = new Button("Refresh", 190, 80, 100, 25);
            close = new Button("Close", 190, 115, 100, 25);
            // get the list of serial ports on the computer
            serial_list = Serial.list()[serial_list_index];

            //println(Serial.list());
            //println(Serial.list().length);

            // get the number of serial ports in the list
            num_serial_ports = Serial.list().length;
        }

        public void draw() {
            btn_serial_up.Draw();
            btn_serial_dn.Draw();
            btn_serial_connect.Draw();
            btn_serial_disconnect.Draw();
            btn_serial_list_refresh.Draw();
            close.Draw();
            // draw the text box containing the selected serial port
            DrawTextBox("Select Port", serial_list, 10, 10, 120, 60);
        }

        public void mousePressed() {
            // up button clicked
            if (btn_serial_up.MouseIsOver()) {
                if (serial_list_index > 0) {
                    // move one position up in the list of serial ports
                    serial_list_index--;
                    serial_list = Serial.list()[serial_list_index];
                }
            }
            // down button clicked
            if (btn_serial_dn.MouseIsOver()) {
                if (serial_list_index < (num_serial_ports - 1)) {
                    // move one position down in the list of serial ports
                    serial_list_index++;
                    serial_list = Serial.list()[serial_list_index];
                }
            }
            // Connect button clicked
            if (btn_serial_connect.MouseIsOver()) {
                if (serial_port == null) {
                    // connect to the selected serial port
                    serial_port = new Serial(this, Serial.list()[serial_list_index], 115200);
                    close();
                }
            }
            // Disconnect button clicked
            if (btn_serial_disconnect.MouseIsOver()) {
                if (serial_port != null) {
                    // disconnect from the serial port
                    serial_port.stop();
                    serial_port = null;
                }
            }
            // Refresh button clicked
            if (btn_serial_list_refresh.MouseIsOver()) {
                // get the serial port list and length of the list
                serial_list = Serial.list()[serial_list_index];
                num_serial_ports = Serial.list().length;
            }
            if (close.MouseIsOver())
                close();
        }

        void close() {
            Frame frame = ((SmoothCanvas) ((PSurfaceAWT) surface).getNative()).getFrame();
            frame.dispose();
        }

        void DrawTextBox(String title, String str, int x, int y, int w, int h) {
            fill(255);
            rect(x, y, w, h);
            fill(0);
            textAlign(LEFT);
            textSize(14);
            text(title, x + 10, y + 10, w - 20, 20);
            textSize(12);
            text(str, x + 10, y + 40, w - 20, h - 10);
        }

        class Button {
            String label;
            float x;    // top left corner x position
            float y;    // top left corner y position
            float w;    // width of button
            float h;    // height of button

            // constructor
            Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
                label = labelB;
                x = xpos;
                y = ypos;
                w = widthB;
                h = heightB;
            }

            // draw the button in the window
            void Draw() {
                fill(218);
                stroke(141);
                rect(x, y, w, h, 10);
                textAlign(CENTER, CENTER);
                fill(0);
                text(label, x + (w / 2), y + (h / 2));
            }

            // returns true if the mouse cursor is over the button
            boolean MouseIsOver() {
                if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
                    return true;
                }
                return false;
            }
        }

    }
