import { Devvit, useState } from '@devvit/public-api';

Devvit.configure({
  redditAPI: true,
});

// Add a custom post type for the game
Devvit.addCustomPostType({
  name: 'basketALL Game',
  height: 'tall',
  render: (context) => {
    const [showGame, setShowGame] = useState(false);

    if (showGame) {
      return (
        <webview
          url="index.html"
          width="100%"
          height="100%"
        />
      );
    }

    return (
      <vstack height="100%" width="100%" alignment="center middle" backgroundColor="#1a1a2e">
        <text size="xxlarge" color="white" weight="bold">basketALL</text>
        <spacer size="medium" />
        <text size="large" color="#4ecdc4">Where Basketball Meets Football!</text>
        <spacer size="large" />
        <vstack backgroundColor="#2d2d44" padding="medium" cornerRadius="medium">
          <text color="white">7v7 Hybrid Sport Game</text>
          <text color="#888">Moving basket - 4 downs - 24-sec shot clock</text>
        </vstack>
        <spacer size="large" />
        <button appearance="primary" onPress={() => setShowGame(true)}>
          Play Game
        </button>
      </vstack>
    );
  },
});

// Add menu item to create a new game post
Devvit.addMenuItem({
  label: 'Create basketALL Game',
  location: 'subreddit',
  onPress: async (event, context) => {
    const subreddit = await context.reddit.getCurrentSubreddit();
    await context.reddit.submitPost({
      title: 'basketALL - Where Basketball Meets Football!',
      subredditName: subreddit.name,
      preview: (
        <vstack height="100%" width="100%" alignment="center middle" backgroundColor="#1a1a2e">
          <text size="large" color="white">Loading basketALL...</text>
        </vstack>
      ),
    });
    context.ui.showToast('Game post created!');
  },
});

export default Devvit;
