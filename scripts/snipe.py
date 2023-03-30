#!/usr/bin/python3

import os
import time
import os.path
import discord
import datetime
from discord import Member
from discord.ext import commands
from discord.ext.commands import has_permissions, MissingPermissions
from discord.ext import tasks


prefix = '..' ## prefix setting ##
owner = 'Shaun#1738' ## defines owner of bot ##
bot_token = 'OTMyNzk4NjE5ODM5NTA0NDI0.YeYOaQ.zl3wg20lRb_-5sLMs0yDPV7e6NM' ## required for authorisation ##


intents = discord.Intents.all()
botVer = 'v1.1'
if os.name == 'nt':
    os.system('cls')
else:
    os.system('clear')
client = commands.Bot(command_prefix=str(prefix), intents=intents)
global startTime
startTime = time.time()
client.remove_command('help')

def randColor():
    return discord.Color.random()

@client.command()
@has_permissions(ban_members=True)
async def help(ctx):
    e = discord.Embed(title='Command Help', description=f'Prefix: `{prefix}`\n\n`{str(prefix)}snipe`: See the most recently deleted message in this channel.\n`{str(prefix)}esnipe`: See the most recently edited message in this channel.\n`{str(prefix)}ping`: Displays the bots latency in ms.', color=randColor())
    await ctx.send(embed=e)

@client.command()
@has_permissions(ban_members=True)
async def ping(ctx: commands.Context):
    await ctx.send(f"Ping pong! I'm alive! {round(client.latency * 1000)}ms")

@client.event
async def on_ready():
    print(f'Logged on to Discord as {client.user.name}')
    print('====================')
    print('Some client info:')
    print('------------------')
    print(f'  Latency: {round(client.latency * 1000)}ms')
    print(f'  Startup time: {round(startTime)}')
    print(f'  Owner: {str(owner)}')
    print('------------------')
    print('====================')

snipe_message_content = {}
snipe_message_author = {}
editsnipe_message_before_content = {}
editsnipe_message_after_content = {}
editsnipe_message_author = {}

@client.event
async def on_message_delete(message):
    if not message.author.bot:
        guild = client.guilds[0]
        channel = message.channel
        snipe_message_author[message.channel.id] = message.author
        snipe_message_content[message.channel.id] = message.content

@client.event
async def on_message_edit(message_before, message_after):
    if not message_after.author.bot:
        editsnipe_message_author[message_before.channel.id] = message_before.author
        guild = message_before.guild.id
        channel = message_before.channel
        editsnipe_message_before_content[channel.id] = message_before.content
        editsnipe_message_after_content[channel.id] = message_after.content

@client.command()
@has_permissions(ban_members=True)
async def snipe(ctx):
    channel = ctx.channel
    try:
        em = discord.Embed(name = f"Last deleted message in #{channel.name}", description = snipe_message_content[channel.id], color=randColor())
        em.set_footer(text = f"This message was sent by {snipe_message_author[channel.id]}")
        await ctx.send(embed = em)
    except:
        await ctx.send(f"There are no recently deleted messages in <#{channel.id}>")

@client.command()
@has_permissions(ban_members=True)
async def esnipe(ctx):
    channel = ctx.channel
    try:
        em = discord.Embed(description=f'**Message before**:```{editsnipe_message_before_content[ctx.channel.id]}```\n**Message after**:```{editsnipe_message_after_content[ctx.channel.id]}```', color=randColor())
        em.set_footer(text=f'This message was edited by {editsnipe_message_author[channel.id]}')
        await ctx.send(embed = em)
    except:
        await ctx.reply(f'There are no recently edited messages in <#{ctx.channel.id}>')

client.run(str(bot_token))
