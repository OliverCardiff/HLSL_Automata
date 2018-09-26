using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Media;
using Microsoft.Xna.Framework.Net;
using Microsoft.Xna.Framework.Storage;

namespace LifeMKII
{
    /// <summary>
    /// This is the main type for your game
    /// </summary>
    public class Game1 : Microsoft.Xna.Framework.Game
    {
        GraphicsDeviceManager graphics;
        SpriteBatch spriteBatch;
        Texture2D noise;
        Texture2D back;
        Effect effect;
        Effect deRed;
        float currentTime;
        int intTime;
        Random rand = new Random();
        public static int ScreenX = 800;
        public static int ScreenY = 600;

        RenderTarget2D targetA;
        RenderTarget2D targetB;

        const int PLAY_RATE = 1;
        const int FRAMES_BETWEEN_SPAWNS = 50;

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
        }

        protected override void Initialize()
        {
            graphics.PreferredBackBufferHeight = ScreenY;
            graphics.PreferredBackBufferWidth = ScreenX;
            graphics.GraphicsDevice.RenderState.MultiSampleAntiAlias = true;
            graphics.ApplyChanges();

            base.Initialize();
        }

        /// <summary>
        /// LoadContent will be called once per game and is the place to load
        /// all of your content.
        /// </summary>
        protected override void LoadContent()
        {
            // Create a new SpriteBatch, which can be used to draw textures.
            spriteBatch = new SpriteBatch(GraphicsDevice);
            MakeNoise();
            effect = Content.Load<Effect>("Life");
            deRed = Content.Load<Effect>("deRed");
            back = Content.Load<Texture2D>("bigblack");

            targetA = new RenderTarget2D(graphics.GraphicsDevice, ScreenX, ScreenY, 1, SurfaceFormat.Color);
            targetB = new RenderTarget2D(graphics.GraphicsDevice, ScreenX, ScreenY, 1, SurfaceFormat.Color);
            // TODO: use this.Content to load your game content here
        }

        private void MakeNoise()
        {
            Color[] colors = new Color[ScreenX * ScreenY];

            for (int i = 0; i < colors.Length; i++)
            {
                colors[i] = new Color((float)rand.NextDouble()* 0.99f + 0.01f, 0, 0, 1);

            }
            noise = new Texture2D(graphics.GraphicsDevice, ScreenX, ScreenY);
            noise.SetData<Color>(colors);
        }
        /// <summary>
        /// UnloadContent will be called once per game and is the place to unload
        /// all content.
        /// </summary>
        protected override void UnloadContent()
        {
            // TODO: Unload any non ContentManager content here
        }

        /// <summary>
        /// Allows the game to run logic such as updating the world,
        /// checking for collisions, gathering input, and playing audio.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Update(GameTime gameTime)
        {
            // Allows the game to exit
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed)
                this.Exit();

            // TODO: Add your update logic here

            base.Update(gameTime);
        }

        /// <summary>
        /// This is called when the game should draw itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Draw(GameTime gameTime)
        {
            intTime++;
            if (intTime < 0)
            {
                intTime = 0;
            }

            if (intTime % PLAY_RATE == 0)
            {
                graphics.GraphicsDevice.SetRenderTarget(0, targetA);

                GraphicsDevice.Clear(Color.Black);
                currentTime += (float)gameTime.ElapsedGameTime.Milliseconds / 1000.0f;
                if (currentTime < 0)
                {
                    currentTime = 0;
                }
                effect.Parameters["xTexture"].SetValue(noise);
                effect.Parameters["xTime"].SetValue(currentTime);
                effect.Parameters["xScreenSize"].SetValue(new Vector2(ScreenX, ScreenY));

                effect.Begin();

                spriteBatch.Begin(SpriteBlendMode.None, SpriteSortMode.Immediate, SaveStateMode.SaveState);

                effect.CurrentTechnique.Passes[0].Begin();

                spriteBatch.Draw(back, new Rectangle(0,0, ScreenX, ScreenY), Color.White);

                effect.CurrentTechnique.Passes[0].End();

                spriteBatch.End();

                effect.End();
                graphics.GraphicsDevice.SetRenderTarget(0, targetB);
                GraphicsDevice.Clear(Color.Black);

                //effect.Parameters["xBlueSpawn"].SetValue(true);
                if (intTime % (FRAMES_BETWEEN_SPAWNS * PLAY_RATE) == 0)
                {
                    effect.Parameters["xGreenSpawn"].SetValue(true);
                }
                else
                {
                    effect.Parameters["xGreenSpawn"].SetValue(false);
                }

                if ((intTime) % (FRAMES_BETWEEN_SPAWNS * PLAY_RATE) == 0)
                {
                    effect.Parameters["xBlueSpawn"].SetValue(true);
                }
                else
                {
                    effect.Parameters["xBlueSpawn"].SetValue(false);
                }
                if (Keyboard.GetState().IsKeyDown(Keys.Space))
                {
                    effect.Parameters["xRandomise"].SetValue(true);
                }
                else
                {
                    effect.Parameters["xRandomise"].SetValue(false);
                }
                effect.Begin();

                spriteBatch.Begin(SpriteBlendMode.None, SpriteSortMode.Immediate, SaveStateMode.SaveState);

                effect.CurrentTechnique.Passes[1].Begin();

                spriteBatch.Draw(targetA.GetTexture(), Vector2.Zero, Color.White);

                effect.CurrentTechnique.Passes[1].End();

                spriteBatch.End();

                effect.End();

                graphics.GraphicsDevice.SetRenderTarget(0, null);

                graphics.GraphicsDevice.Clear(Color.Black);

                back = targetB.GetTexture();

                deRed.Begin();
                spriteBatch.Begin(SpriteBlendMode.None, SpriteSortMode.Immediate, SaveStateMode.SaveState);
                deRed.CurrentTechnique.Passes[0].Begin();
                spriteBatch.Draw(back, Vector2.Zero, Color.White);
                deRed.CurrentTechnique.Passes[0].End();
                spriteBatch.End();
                deRed.End();

                // TODO: Add your drawing code here
            }
            base.Draw(gameTime);
        }
    }
}
