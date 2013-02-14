#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxMaxim.h"
#include "ofxUI.h"


class testApp : public ofxiPhoneApp {
	
public:
	~testApp();
	void setup();
	void update();
	void draw();
	void exit();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	void touchCancelled(ofTouchEventArgs &touch);

	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
	void deviceOrientationChanged(int newOrientation);
    
    //grid
    void drawGrid(float x, float y); 
	
    //sound+Maxim
	void audioReceived( float * input, int bufferSize, int nChannels );
	void audioRequested( float * output, int bufferSize, int nChannels );
	
	int		initialBufferSize;
	int		sampleRate;
	
	
//	ofxMaxiOsc myOsc1;
//	ofxMaxiSample sample1;
//	double patch1,sample,outputs1[2];
//	ofxMaxiMix channel1;
    
    //image
    ofImage     imgSketch;
    ofImage     imgCompass;
    
    //UI
    ofxUICanvas *gui1,*gui2,*gui3;   	
	void guiEvent(ofxUIEventArgs &e);
    bool drawPadding; 
	int beat1, beat2; 

};


