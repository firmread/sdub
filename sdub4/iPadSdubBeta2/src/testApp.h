#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxMaxim.h"
#include "ofxUI.h"

typedef hannWinFunctor grainPlayerWin;

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
	void audioIn( float * input, int bufferSize, int nChannels );
	void audioOut( float * output, int bufferSize, int nChannels );
	
	float   * lAudioIn;
	float   * rAudioIn;
    
    float 	* lAudioOut; 
	float   * rAudioOut;
    
	int		initialBufferSize;
	int		sampleRate;
	int		drawCounter, bufferCounter;
	float 	* buffer;
	
	
	ofxMaxiOsc          myOsc1;
    ofxMaxiDelayline    delay;
    ofxMaxiFilter       myFilter;
	ofxMaxiSample       beatSamp,samp2;
	
    vector < maxiPitchStretch < grainPlayerWin> * > stretches;
	
    double          wave,synth1,sample,
                    outputs1[2],outputs2[2];
	ofxMaxiMix      channel1,channel2;
    
	maxiPitchStretch <grainPlayerWin> *ts, *ts2, *ts3, *ts4, *ts5;
	double          speed, grainLength, rate;
    
	ofxMaxiFFT      fft;
	ofxMaxiFFTOctaveAnalyzer    oct;
	int             current;
	double          pos;
    
    //image
    ofImage     imgSketch;
    ofImage     imgCompass;
    ofImage     imgLogo;
    
    //compass
	ofxiPhoneCoreLocation * coreLocation;
	
	float   heading;
    float   sinheading;
    
    float   goDirection;
    float   beatbar;
    float   lati,longi;
	
	bool    hasCompass;
	bool    hasGPS;
    
    //UI
    ofxUICanvas *gui1,*gui2,*gui3;   	
	void    guiEvent(ofxUIEventArgs &e);
    bool    drawPadding; 
	int     beat1, beat2; 

};


