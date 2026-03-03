#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

#include "MainLoop.h"
#include "RenderService.h"
#include "Log.h"

static void _signal_handler(int signo)
{
    UNUSED(signo);

    MainLoop::getInstance().terminate();
}

#include "Page.h"
class HelloWorld : public Page
{
protected:
    void onCreate() override
    {
        setBackground(Color::WHITE);

        int centerY = getHeight() / 2;
        drawRectangle(Rectangle(500, centerY, 100, 100), Color::RED);
        drawCircle(Point(550, centerY - 50), 50, Color::GREEN);
        drawLine(Point(550, centerY - 50), Point(620, centerY + 50), Color::BLUE, 3.0f);

        drawText(Font::DEF_FONT_56, "Hello World", -1, -1, Color::BLACK);
    }
};

int main(int, char**)
{
__TRACE__
    // signal init
    signal(SIGINT,  _signal_handler);
    signal(SIGQUIT, _signal_handler);
    signal(SIGTERM, _signal_handler);

    RenderService::getInstance().start();

    HelloWorld page;
    page.show();

    while(MainLoop::getInstance().loop()) { }

    page.hide();

    RenderService::getInstance().stop();

    return 0;
}
