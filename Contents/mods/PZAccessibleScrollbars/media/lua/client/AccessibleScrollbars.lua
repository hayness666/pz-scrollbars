-- vanilla function in ISScrollBar.lua

-- CREATE OBJECT CLASS USED TO CREATE INSTANCES

function ISScrollBar:instantiate()

    -- CREATE OBJECT TO DRAW SCRCOLLBAR IN JAVA

	self.javaObject = UIElement.new(self);

    -- LUA - CREATE VARIABLES TO USE WHEN POSITIONING SCROLLBAR IN JAVA

    self.anchorRight = true;
    self.anchorBottom = true;

    -- vertical variables - vanilla

	if self.vertical then
		self.anchorLeft = false;
		self.x = self.parent.width - 16; -- (vanilla comment = "FIXME, height is 17")
		self.y = 0;
		self.width = 17;

        -- vertical variables - mod

		if WGS.mod.options.LargeScrollbars or true then 
			self.width = 30 
			self.x = self.parent.width - 29 -- (why is this 1 < 30? test adjusting this)
		end
		
		self.height = self.parent.height;

    -- horizontal variables - vanilla

	else
		self.anchorTop = false
		self.x = 0
		self.y = self.parent.height - 16 -- (vanilla comment = "FIXME, height is 17")
		self.width = self.parent.width - (self.parent.vscroll and 13 or 0)
		self.height = 17
        
        -- horizontal variables - mod
		
		if WGS.mod.options.LargeScrollbars or true then 
			self.height = 30 
			self.y = self.parent.height - 29 -- ?
		end
	end

    -- JAVA - POSITION SCROLLBARS USING LUA VARIABLES

	self.javaObject:setX(self.x);
	self.javaObject:setY(self.y);
	self.javaObject:setHeight(self.height);
	self.javaObject:setWidth(self.width);
	self.javaObject:setAnchorLeft(self.anchorLeft);
	self.javaObject:setAnchorRight(self.anchorRight);
	self.javaObject:setAnchorTop(self.anchorTop);
	self.javaObject:setAnchorBottom(self.anchorBottom);
    self.javaObject:setScrollWithParent(false);
end

-----------------------------------------------------------------

-- 

function ISScrollBar:render()

	if self.vertical then
		local sh = self.parent:getScrollHeight();

		if(sh > self:getHeight()) then
			if self.doSetStencil then
				self:setStencilRect(0, 0, self.width, self.height)
			end

            if self.background then
			    self:drawRect(4, 0, self.width - 4 - 1, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
            end

			local del = self:getHeight() / sh;
			local boxheight = del * (self:getHeight() - (16 * 2));

			boxheight = math.ceil(boxheight)
			boxheight = math.max(boxheight, 8)

			local dif = self:getHeight() - (16 * 2) - boxheight ;

			dif = dif * self.pos;
			dif = math.ceil(dif)

			self.barx = 4;
			self.bary = 16 + dif;
			self.barwidth = 8;
			self.barheight = boxheight;

            ------------------------------------------------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------------------------------------------------
            -- Play with this using your own module until you get the texture sizes and such how you like them. You could even make your own. --
            ------------------------------------------------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------------------------------------------------
            
            if WGS.mod.options.LargeScrollbars or true then 
                self.barwidth = 30
                self.barx = 15 

                self.newButtonSize = 16

                self:drawTextureScaled(self.uptex, 8, 0, self.newButtonSize, self.newButtonSize, 1, 1, 1, 1);
                self:drawTextureScaled(self.downtex, 8, self.height - 20, self.newButtonSize, self.newButtonSize, 1, 1, 1, 1);
    
                self:drawTextureScaled(self.midtex, 5, self.bary+2, 20, self.barheight-4, 1, 1, 1, 1);
                self:drawTextureScaled(self.toptex, 5, self.bary, 20, 1, 1, 1, 1, 1);
                self:drawTextureScaled(self.bottex, 5, (self.bary+self.barheight)-3, 20, 1, 1, 1, 1, 1);
    
                self:drawRectBorder(3, 0, self:getWidth()-4, self:getHeight(), self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
            else

                self:drawTexture(self.uptex, 1+3, 0, 1, 1, 1, 1);
                self:drawTexture(self.downtex, 1+3, self.height - 20, 1, 1, 1, 1);

                self:drawTextureScaled(self.midtex, 2+3, self.bary+2, 9, self.barheight-4, 1, 1, 1, 1);
                self:drawTexture(self.toptex, 2+3, self.bary, 1, 1, 1, 1);
                self:drawTexture(self.bottex, 2+3, (self.bary+self.barheight)-3, 1, 1, 1, 1);

                self:drawRectBorder(3, 0, self:getWidth()-4, self:getHeight(), self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
            
            end
			
            if self.doSetStencil then
				self:clearStencilRect()
			end
			
            if self.doRepaintStencil then
--				self:repaintStencilRect(0, 0, self.width, self.height)
			end
        else
			self.barx = 0;
			self.bary = 0;
			self.barwidth = 0;
			self.barheight = 0;
		end
	else
		local sw = self.parent:getScrollWidth()
		if sw > self:getWidth() then
			if self.doSetStencil then
				self:setStencilRect(0, 0, self.width, self.height)
			end
			if self.background then
				self:drawRect(4, 0, self.width - 4 - 1, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
			end

			local del = self:getWidth() / sw
			local boxwidth = del * (self:getWidth() - (16 * 2))
			boxwidth = math.ceil(boxwidth)
			boxwidth = math.max(boxwidth, 8)

			local dif = self:getWidth() - (16 * 2) - boxwidth
			dif = dif * self.pos
			dif = math.ceil(dif)

			self.barx = 16 + dif
			self.bary = 4
			self.barwidth = boxwidth
			self.barheight = 8

            if WGS.mod.options.LargeScrollbars or true then 
                self.barheight = 30
                self.bary = 15
            end

            -------------------------------------------------
            -------------------------------------------------
            -------------------------------------------------
            ----You will want to do horizontal bars, too.----
            -------------------------------------------------
            -------------------------------------------------



			self:drawTexture(self.uptex, 0, 1+3, 1, 1, 1, 1)
			self:drawTexture(self.downtex, self.width - 20, 1+3, 1, 1, 1, 1)

			self:drawTextureScaled(self.midtex, self.barx+2, 2+3, self.barwidth-4, 9, 1, 1, 1, 1)
			self:drawTexture(self.toptex, self.barx, 2+3, 1, 1, 1, 1)
			self:drawTexture(self.bottex, (self.barx+self.barwidth)-3, 2+3, 1, 1, 1, 1)

			self:drawRectBorder(0, 3, self:getWidth(), self:getHeight()-4, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)
			if self.doSetStencil then
				self:clearStencilRect()
			end
			if self.doRepaintStencil then
--				self:repaintStencilRect(0, 0, self.width, self.height)
			end
		else
			self.barx = 0
			self.bary = 0
			self.barwidth = 0
			self.barheight = 0
		end
	end
end
