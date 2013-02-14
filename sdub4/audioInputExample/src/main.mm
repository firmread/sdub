#include "ofMain.h"
#include "testApp.h"

int main(){
//	ofSetupOpenGL(1024,768, OF_FULLSCREEN);			// <-------- setup the GL context
//
//	ofRunApp(new testApp());

    ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow();  
    iOSWindow->enableAntiAliasing(4);  
    iOSWindow->enableRetinaSupport();  
    ofSetupOpenGL(iOSWindow, 1024, 768, OF_FULLSCREEN);  
    ofRunApp(new testApp);  
    
}
