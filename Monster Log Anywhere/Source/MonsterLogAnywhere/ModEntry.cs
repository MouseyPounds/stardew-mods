using StardewModdingAPI;
using StardewModdingAPI.Events;
using StardewValley;
using StardewValley.Locations;
using System.Collections.Generic;

namespace MonsterLogAnywhere
{
    public class ModEntry : Mod, IAssetEditor
    {
        private ModConfig Config;
        public override void Entry(IModHelper helper)
        {
            this.Config = helper.ReadConfig<ModConfig>();

            helper.Events.Input.ButtonPressed += this.OnButtonPressed;
        }

        private void OnButtonPressed(object sender, ButtonPressedEventArgs e)
        {
            if (e.Button == this.Config.Monster_Log_Keybind)
            {
                this.Monitor.Log("Caught button pressed event", LogLevel.Trace);
                if (Game1.activeClickableMenu == null)
                {
                    this.Monitor.Log("Showing the log", LogLevel.Debug);
                    ((AdventureGuild)Game1.getLocationFromName("AdventureGuild")).showMonsterKillList();
                }
                else
                {
                    this.Monitor.Log("Can't show log because a menu is up.", LogLevel.Debug);
                }
                
            }
        }

        public bool CanEdit<T>(IAssetInfo asset)
        {
            if (this.Config.Change_Header_and_Footer && asset.AssetNameEquals("Strings/Locations"))
            {
                return true;
            }

            return false;
        }

        public void Edit<T>(IAssetData asset)
        {
            if (this.Config.Change_Header_and_Footer && asset.AssetNameEquals("Strings/Locations"))
            {
                IDictionary<string, string> data = asset.AsDictionary<string, string>().Data;

                data["AdventureGuild_KillList_Header"] = this.Config.New_Header;
                data["AdventureGuild_KillList_Footer"] = this.Config.New_Footer;
            }
        }
    }
}