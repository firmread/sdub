#include "testApp.h"

testApp::~testApp() {
	
//	delete sample1.myData;
	
}


//--------------------------------------------------------------
void testApp::setup(){
	ofEnableAlphaBlending();
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	sampleRate 			= 44100;
	initialBufferSize	= 512;
	
//	sample1.load(ofToDataPath("beat2.wav"));

	ofSoundStreamSetup(2,0,this, sampleRate, initialBufferSize, 4);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(100,100,100);
    
    //Image
    imgSketch.loadImage("padUI.png");
    imgCompass.loadImage("compass.png");
    
    //variables
    beat1 = 120;
    beat2 = 120;
    
    //UI
	float dim = 30; 
	float xInit = OFX_UI_GLOBAL_WIDGET_SPACING; 
    float length = 260-xInit; 
	
    drawPadding = false; 
    
    gui1 = new ofxUICanvas(30,120,length+xInit,640);     
	
	gui1->addWidgetDown(new ofxUILabel("BEAT IN", OFX_UI_FONT_MEDIUM)); 	
    gui1->addWidgetDown(new ofxUISlider(length-xInit,dim, 60, 200, beat1, "Beat in 1")); 
	gui1->addWidgetDown(new ofxUISlider(length-xInit,dim, 60, 200, beat2, "Beat in 2")); 
    
    gui1->addWidgetDown(new ofxUISpacer(length-xInit, length-xInit)); 
	gui1->addWidgetDown(new ofxUILabel("COMPASS", OFX_UI_FONT_MEDIUM)); 
    
	gui1->addWidgetDown(new ofxUI2DPad(length-xInit,160, ofPoint((length-xInit)*.5,190*.5), "NEW YORK")); 	
	gui1->addWidgetDown(new ofxUILabel("CITY", OFX_UI_FONT_MEDIUM)); 
    
    ofAddListener(gui1->newGUIEvent,this,&testApp::guiEvent);	
    
    
    float length2 = 700-xInit;
    gui2 = new ofxUICanvas(30,780,length2+xInit,200);  
    
	gui2->addWidgetDown(new ofxUI2DPad(length2-xInit,160, ofPoint((length2-xInit)*.5,190*.5), "LAT.LONG")); 	
	gui2->addWidgetDown(new ofxUILabel("WORLD", OFX_UI_FONT_MEDIUM)); 
    
    ofAddListener(gui2->newGUIEvent,this,&testApp::guiEvent);
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
    ofEnableAlphaBlending();
    
    ofSetColor(255, 255, 255, 25);	
    drawGrid(10,10);
    
    ofSetColor(255, 255, 255, 50);	
    drawGrid(50,50); 
    
    ofSetColor(255, 255, 255,100);
    imgSketch.draw(0,0);
    
    ofRect(310, 550, 420, 210);
    
    ofDisableAlphaBlending();
    
//    imgCompass.draw(160-120,380-120,240,240);
    
}

//--------------------------------------------------------------
void testApp::guiEvent(ofxUIEventArgs &e)
{
	string name = e.widget->getName(); 
	int kind = e.widget->getKind(); 
	
	if(name == "Beat in 1")
	{
		ofxUISlider *slider = (ofxUISlider *) e.widget; 
		beat1 = slider->getScaledValue(); 
        cout << "value: " << slider->getScaledValue() << endl; 
	}
	else if(name == "Beat in 2")
	{
		ofxUISlider *slider = (ofxUISlider *) e.widget; 
		beat2 = slider->getScaledValue(); 
        cout << "value: " << slider->getScaledValue() << endl; 
	}
//    else if(name == "RSLIDER")
//    {
//        ofxUIRangeSlider *rslider = (ofxUIRangeSlider *) e.widget; 
//        cout << "valuelow: " << rslider->getScaledValueLow() << endl; 
//        cout << "valuehigh: " << rslider->getScaledValueHigh() << endl;   
//    }
    else if(name == "NEW YORK")
    {
        ofxUI2DPad *pad = (ofxUI2DPad *) e.widget; 
        cout << "value x: " << pad->getScaledValue().x << endl; 
        cout << "value y: " << pad->getScaledValue().y << endl;         
    }
//    else if(name == "CSLIDER" || name == "CSLIDER 2")
//    {
//        ofxUIRotarySlider *rotslider = (ofxUIRotarySlider *) e.widget; 
//        cout << "value: " << rotslider->getScaledValue() << endl; 
//    }
    else if(name == "LAT.LONG")
    {
        ofxUI2DPad *pad = (ofxUI2DPad *) e.widget; 
        cout << "value x: " << pad->getScaledValue().x << endl; 
        cout << "value y: " << pad->getScaledValue().y << endl;         
    }
}    
//--------------------------------------------------------------
void testApp::exit(){
    
    delete gui1; 
    delete gui2; 
    delete gui3; 

}

//--------------------------------------------------------------
void testApp::audioRequested(float * output, int bufferSize, int nChannels){
	
	if( initialBufferSize != bufferSize ){
		ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
		return;
	}	
	
	for (int i = 0; i < bufferSize; i++){
		
//		sample=sample1.play(1.);
//		channel1.stereo(sample,outputs1,0.5);
//		
//		output[i*nChannels    ] = outputs1[0];
//		output[i*nChannels + 1] = outputs1[1];
		
	}
	
}

//--------------------------------------------------------------
void testApp::audioReceived(float * input, int bufferSize, int nChannels){
	
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){
	
}

//--------------------------------------------------------------

void testApp::drawGrid(float x, float y)
{
    float w = ofGetWidth(); 
    float h = ofGetHeight(); 
    
    for(int i = 0; i < h; i+=y){
        ofLine(0,i,w,i); 
    }
    
    for(int j = 0; j < w; j+=x){
        ofLine(j,0,j,h); 
    }    
}

