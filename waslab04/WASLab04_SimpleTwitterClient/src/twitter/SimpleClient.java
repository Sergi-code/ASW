package twitter;


import twitter4j.FilterQuery;
import twitter4j.StallWarning;
import twitter4j.Status;
import twitter4j.StatusDeletionNotice;
import twitter4j.StatusListener;
import twitter4j.TwitterStream;
import twitter4j.TwitterStreamFactory;

public class SimpleClient {

	public static void main(String[] args) throws Exception {
		
		TwitterStream twitter = new TwitterStreamFactory().getInstance();

		StatusListener status = new StatusListener () {
			
			@Override
			public void onStatus(Status arg0) {
				// TODO Auto-generated method stub
				System.out.println(arg0.getUser().getName() + " (@" + arg0.getUser().getScreenName() + "): " + arg0.getText());
				
			}

			@Override
			public void onException(Exception arg0) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onDeletionNotice(StatusDeletionNotice arg0) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onScrubGeo(long arg0, long arg1) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onStallWarning(StallWarning arg0) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onTrackLimitationNotice(int arg0) {
				// TODO Auto-generated method stub
				
			}
		};
		
		twitter.addListener(status);
		
		FilterQuery fq = new FilterQuery().track("#covid19");
		twitter.filter(fq);
		
	}
}