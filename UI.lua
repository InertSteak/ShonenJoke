function shonen_joke.config_tab()
    config_nodes = {create_toggle({label = localize("shon_finished"), ref_table = shonen_joke.config, ref_value = "allow_finished",
    callback = function(_set_toggle)
        NFS.write(shonen_joke.mod_dir .. "/config.lua", STR_PACK(shonen_joke.config))
    end}),
    create_toggle({label = localize("shon_rare_rarity"), ref_table = shonen_joke.config, ref_value = "shon_rare_rarity",
    callback = function(_set_toggle)
        NFS.write(shonen_joke.mod_dir .. "/config.lua", STR_PACK(shonen_joke.config))
    end}),
    }

    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 10,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK
        },
        nodes = config_nodes
    }
end

SMODS.current_mod.config_tab = function()
    return shonen_joke.config_tab()
end