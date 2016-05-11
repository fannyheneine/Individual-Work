# Video poker made its entry to the casino in the seventies; and is today one of the most popular 
# forms of gambling.The rules of video poker are simple; you play 1 to 5 coins, the machine gives
# you five cards, you choose which to hold and which to discard, the machine replaces your 
# discards and pays you off according to the value of your hand

# Note: The machine gives you money if you have a pair of jacks or higher only!
# For the other hands, the higher is your hand, the more money the machine hands out.

ranks <- seq(2, 14)
colors <- seq(1, 4)
deck <- matrix(rep(FALSE, 4*13), nrow=13, ncol=4)
colnames(deck) <- c("Clubs", "Diamonds", "Hearts", "Spades")
row.names(deck) <- c( "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King","Ace")

################################################################################################
## Profit at each hand, x being the amount invested
none.rev <- function(x)
{
  rev=0-x
  rev
}

jacks.or.better.rev <- function(x)
{
  rev=x-x
  rev
}

twopairs.rev<- function(x)
{
  rev=2*x-x
  rev
}

triple.rev<- function(x)
{
  rev=3*x-x
  rev
}

straight.rev <- function(x)
{
  rev=5*x-x
  rev
}

flush.rev <- function(x)
{
  rev=7*x-x
  rev
}

full.house.rev <- function(x)
{
  rev=10*x-x
  rev
}

quad.rev <- function(x)
{
  rev=40*x-x
  rev
}

straight.flush.rev <- function(x)
{
  rev=50*x-x
  rev
}


royal.straigt.flush.rev <- function(x)
{
  rev=800*x-x
  rev
}

revenues<-c(none.rev(10),jacks.or.better.rev(10),twopairs.rev(10),triple.rev(10),full.house.rev(10),quad.rev(10))
################################################################################################
################################################################################################
## PROBABILITIES OF WINNING AT THE FIRST HAND?
## REVENUE EXPECTANCY? VISULIZATIONS AND PLOTS !! BAR PLOTS?

#Deal the first hand
hand1 <- function() {
  card.ranks <- sample(2:14, 5,replace=TRUE)
  card.colors <- sample(colors, size=5, replace=TRUE)
  deck[list(13*(card.colors-1)+card.ranks-1) [[1]]]<- TRUE 
  #we do -1 because our sequence starts at 2 instead of 1, so the indexes are -1
  deck
}

hand1()

probs <- function(m) {
  testing0<-matrix(0,nrow=1,ncol=5)
  sapply(1:m, function(o)
  {
    hand.first<-hand1()
    if (one.pair(hand.first)==1){
      testing0[,1]<-testing0[,1]+1
    }
    else if (two.pairs(hand.first)==1) {
      testing0[,2]<-testing0[,2]1  
    }
    else if (triple(hand.first)==1){
      testing0[,3]<-testing0[,3]1
    }
    else if (full.house(hand.first)==1){
      testing0[,4]<-testing0[,4]1
    }
    else if (four(hand.first)==1){
      testing0[,5]<-testing0[,5]1
    }
    testing0
  })
}

M<-100000
total<-rowSums(probs(M))
total
probabs<-total/M*100
probabs
loss<-100-sum(probabs)

# We can see that we definitely have more chances to win at the second hand rather than at the first:
# We have a loss percentage of 84.7% at first hand, while we have a loss percentage of 71.4% at second
# hand.

barplot(total, main="Poker hands", ylab="Count ",names.arg=c("one pair","two pairs","triple","full house","quad"), 
        las=2, col="blue",ylim=c(0,15000))
Poker_Hands<-c("One-pair", "Two-pairs", "Triple", "Full-House","Quad")
revenue<-revenues[2:6]
qplot(Poker_Hands, probabs, geom="bar", stat="identity", fill=revenue, ylab="Probability in %", main="Probabilities of winning at first hand", 
      labels=c("One-pair", "Two-pairs", "Triple", "Full-House","Quad"),
      scale_fill_manual(values=c('blue', 'purple'), xlab="Poker Hands",scale_x_discrete(breaks=c("One-pair", "Two-pairs", "Triple", "Full-House","Quad"))))

################################################################################################
# What are the probabilities of going from one low pair to two pairs? To a triple? To a full house?
# To a 4 of the same kind?

# DECK SETUP AND WINNING CHECKS
ranks <- seq(2, 14)
colors <- seq(1, 4)
deck <- matrix(rep(FALSE, 4*13), nrow=13, ncol=4)
colnames(deck) <- c("Heart", "Diamond", "Spade", "Club")
row.names(deck) <- c("2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace")

one.pair <- function(hand) 
{
  test<- which(rowSums(hand)[10:13]==2)
  pair=0
  if (length(test)==1) {
    pair=1
  }
  pair
}


two.pairs <- function(hand) 
{
  test<- which(rowSums(hand)==2)
  tpairs=0
  if (length(test)==2) {
    tpairs=1
  }
  tpairs
}

triple <- function(hand) 
{
  test<- which(rowSums(hand)==3)
  triples=0
  if (length(test)==1) {
    triples=1
  }
  triples
}


four <- function(hand) 
{
  test<- which(rowSums(hand)==4)
  quad=0
  if (length(test)==1) {
    quad=1
  }
  else {
    quad=0
  }
  quad
}


full.house <- function(hand) 
{
  test<- c(which(rowSums(hand)==2),which(rowSums(hand)==3))
  flh=0
  if (length(test)==2 && two.pairs(hand)==0) {
    flh=1
  }
  flh
}
 
#===================================================================================================
# PROBABILITIES OF GOING FROM A LOW PAIR TO A TWO-PAIRS, TRIPLE, FULL HOUSE AND QUAD

#Deal the first hand, consisting of a pair of low cards and three other random cards (no pairs, 
# no triples, no 4)
hand3 <- function() {
  #Choose the low pair
  low.rank <- sample(2:10, 1)
  low.color <- sample(colors, size=2, replace=FALSE)
  #Choose the remaining cards. Can't be the same rank, or cannot have another pair
  # Because sample is by default set to replace=FALSE, no other pair can be drawn here
  rem.ranks <- sample(seq(2, 14)[-c(low.rank-1)], 3)  #we do -1 because our sequence
  # starts at 2 instead of 1, so the indexes are -1
  rem.colors <- sample(colors, size=3, replace=TRUE)
  #Arrange all cards into a hand.
  card.ranks <- c(low.rank, low.rank, rem.ranks)
  card.colors <- c(low.color, rem.colors)
  deck[list(13*(card.colors-1)+card.ranks-1)[[1]]] <- TRUE  
  deck
}

# Throw away the three cards and keep the pair. Resample 3 new cards
new.hand3<- function(hand) {
  keep<-which(rowSums(hand)==2)
  held<-which(hand & row(hand) == keep)
  discarded <- setdiff(which(hand), held)
  new.c <- sample(which(!hand), size=(5 - length(held)), replace=FALSE)
  hand[discarded] <- FALSE
  hand[new.c] <- TRUE
  hand
}


trials <- function(m) 
{ 
  testing<-matrix(0,nrow=1,ncol=4)
  colnames(testing)<-c("Two-Pairs","Triples","Quadruples","Full.House")
  sapply(1:m, function(o)
  {
    hand<-hand3()
    new.hand<-new.hand3(hand)
    if (two.pairs(new.hand)==1) {
      testing[,1]<-testing[,1]+1  
    }
    else if (triple(new.hand)==1){
      testing[,2]<-testing[,2]+1
    }
    else if (full.house(new.hand)==1){
      testing[,3]<-testing[,3]+1
    }
    else if (four(new.hand)==1){
      testing[,4]<-testing[,4]+1
    }
    testing
  })
}

M<-10000
total<-rowSums(trials(M))
prob.two.pairs=total[1]/M     #0.16216
# Theoretic probability 1/6
prob.triples=total[2]/M      #0.11718
# Theoretic Probability 1/9
prob.fullhouse=total[3]/M    #0
# Theoretic probability is 0
prob.quad=total[4]/M      #0.00279
# Theoretic Probability 1/360


################################################################################################
# What are the probabilities of going from one triple to a full house? To a 4 of the same kind? 
hand4 <- function() {
  #Choose the low pair
  card.rank <- sample(2:14, 1)
  card.color <- sample(colors, size=3, replace=FALSE)
  #Choose the remaining card. Cannot be the same rank.
  rem.rank <- sample(seq(2, 14)[-c(card.rank-1)], 1)  #we do -1 because our sequence
  # starts at 2 instead of 1, so the indexes are -1
  rem.color <- sample(colors, size=1, replace=TRUE)
  #Arrange all cards into a hand.
  card.ranks <- c(card.rank, card.rank, card.rank, rem.rank)
  card.colors <- c(card.color, rem.color)
  deck[list(13*(card.colors-1)+card.ranks-1)[[1]]] <- TRUE  
  deck
}

# Throw away the three cards and keep the pair. Resample 3 new cards
new.hand4<- function(hand) {
  keep<-which(rowSums(hand)==3)
  held<-which(hand & row(hand) == keep)
  discarded <- setdiff(which(hand), held)
  new.c <- sample(which(!hand), size=(5 - length(held)), replace=FALSE)
  hand[discarded] <- FALSE
  hand[new.c] <- TRUE
  hand
}

trials2 <- function(m) 
{ 
  testing<-matrix(0,nrow=1,ncol=2)
  colnames(testing)<-c("Quadruples","Full.House")
  sapply(1:m, function(o)
  {
    hand<-hand4()
    new.hand<-new.hand4(hand)
    if (full.house(new.hand)==1){
      testing[,1]<-testing[,1]+1
    }
    else if (four(new.hand)==1){
      testing[,2]<-testing[,2]+1
    }
    testing
  })
}

M<-100000
total2<-rowSums(trials2(M))
prob.fullhouse2=total2[1]/M    # 0.06139 
# Theoretic probability is 1/16
prob.quad2=total2[2]/M      #  0.04106
# Theoretic Probability 1/24

# DO BAR PLOTS ! With thoeretic probabilities as red lines on top of bar plots.


################################################################################################
# Compare different strategies of card "held" to find the probabilities of which has more chances
# of having as outcome a full house:
# If I get a double (lower than Jack) and a face card, should I just hold the double or the double 
# and the jack? In other words, which has more probability of turning into a gain (pair of jacks or
# higher, two pairs, full house, triples, quad)?


#Deal the first hand, consisting of a pair of low cards, one face card, and two other random cards
#The two random cannot be a face, or the same as the low cards, and cannot have another pair
hand5 <- function() {
  #Choose the low pair
  low.rank <- sample(2:10, 1)
  low.color <- sample(colors, size=2, replace=FALSE)
  #Choose a face card.
  face.rank <- sample(11:14, 1)
  face.color <- sample(colors, size=1)
  #Choose the remaining cards. Cannot be the same as the two previous types, cannot have another
  # pair(as replace=FALSE for sample, we won't get another pair)
  rem.ranks <- sample(seq(2, 14)[-c(face.rank-1, low.rank-1)], 2)  
  rem.colors <- sample(colors, size=2, replace=TRUE)
  #Arrange all cards into a hand.
  card.ranks <- c(low.rank, low.rank, face.rank, rem.ranks)
  card.colors <- c(low.color, face.color, rem.colors)
  deck[list(13*(card.colors-1)+card.ranks-1)[[1]]] <- TRUE  
  deck
}

# We set up a new variable choose which refers to the strategy the player chooses
# choose=0, keep only the pair
# choose=1, keep the pair and the face card
new.hand5<- function(hand,choose) {
  keep<-which(rowSums(hand)==2)
  held<-which(hand & row(hand) == keep)
  if (choose==1){
    keep.t<-intersect(which(hand), which(row(hand) >= 10))
    if (length(keep.t)>1){
      keep2<-sample(keep.t,1)
    }
    else {
      keep2<-keep.t
    }
    held<-c(held,keep2)
  }
  discarded <- setdiff(which(hand), held)
  new.c <- sample(which(!hand), size=(5 - length(held)), replace=FALSE)
  hand[discarded] <- FALSE
  hand[new.c] <- TRUE
  hand
}

# Now compare the outcomes of the two strategies: Use a plot to show revenue as a function of 
# the strategy chosen?
compare <- function(m) {
  testing0<-matrix(0,nrow=1,ncol=10)
  sapply(1:m, function(o)
  {
    hand<-hand5()
    new.hand.choice0<-new.hand5(hand,0)
    new.hand.choice1<-new.hand5(hand,1)
    if (one.pair(new.hand.choice0)==1){
      testing0[,1]<-testing0[,1]+1
    }
    else if (two.pairs(new.hand.choice0)==1) {
      testing0[,2]<-testing0[,2]+1  
    }
    else if (triple(new.hand.choice0)==1){
      testing0[,3]<-testing0[,3]+1
    }
    else if (full.house(new.hand.choice0)==1){
      testing0[,4]<-testing0[,4]+1
    }
    else if (four(new.hand.choice0)==1){
      testing0[,5]<-testing0[,5]+1
    }

    if (one.pair(new.hand.choice1)==1){
      testing0[,6]<-testing0[,6]+1
    }
    else if (two.pairs(new.hand.choice1)==1) {
      testing0[,7]<-testing0[,7]+1  
    }
    else if (triple(new.hand.choice1)==1){
      testing0[,8]<-testing0[,8]+1
    }
    else if (full.house(new.hand.choice1)==1){
      testing0[,9]<-testing0[,9]+1
    }
    else if (four(new.hand.choice1)==1){
      testing0[,10]<-testing0[,10]+1
    }
    testing0
    })
}

M<-100000
count<-rowSums(compare(M))
count2<-c(M-sum(count[1:5]),count[1:5],M-sum(count[6:10]),count[6:10])
probabilities<-count2/M*100
titles <- c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad","Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad")
choice<-c('a','a','a','a','a','a','b','b','b','b','b','b')
  
df<-data.frame(choice,titles,count2,probabilities)
Poker.Hands<-df$titles
qplot(Poker.Hands, df$count2, geom="bar", stat="identity", fill=choice,  position="dodge", alpha = 0.5, ylab="Count", main="Strategy Comparison", 
      labels=c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad"),
      scale_fill_manual(values=c('blue', 'purple'), xlab="Poker Hands",scale_x_discrete(breaks=c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad"))))

strategy0 <- subset(df,choice=="a",select=c(probabilities,titles),row.names= titles) 
qplot(Poker.Hands[2:6], strategy0$probabilities[2:6], geom="bar", stat="identity", fill=revenues[2:6], ylab="Probability in %", main="Probabilities of winning with strategy 0", 
      labels=c("One-pair", "Two-pairs", "Triple", "Full-House","Quad"))
# Revenue expectancy for each strategy
test.revenue <-function(o)
  {
    hand<-hand5()
    x<-5
    new.hand.choice0<-new.hand5(hand,0)
    new.hand.choice1<-new.hand5(hand,1)
    if (one.pair(new.hand.choice0)==1){
      revenue0=jacks.or.better.rev(x)
    }
    else if (two.pairs(new.hand.choice0)==1) {
      revenue0=twopairs.rev(x)
    }
    else if (triple(new.hand.choice0)==1){
      revenue0=triple.rev(x)
    }
    else if (full.house(new.hand.choice0)==1){
      revenue0=full.house.rev(x)
    }
    else if (four(new.hand.choice0)==1){
      revenue0=quad.rev(x)
    }
    else {
      revenue0=none.rev(x)
    }
    
    if (one.pair(new.hand.choice1)==1){
      revenue1=jacks.or.better.rev(x)
    }
    else if (two.pairs(new.hand.choice1)==1) {
      revenue1=twopairs.rev(x) 
    }
    else if (triple(new.hand.choice1)==1){
      revenue1=triple.rev(x)
    }
    else if (full.house(new.hand.choice1)==1){
      revenue1=full.house.rev(x)
    }
    else if (four(new.hand.choice1)==1){
      revenue1=quad.rev(x)
    }
    else {
      revenue1=none.rev(x)
    }
    rev<-c(revenue0,revenue1)
    rev
}

m<-1000
marray<-seq(from=1,to=m,by=1)

REV<-sapply(marray,test.revenue)
REV0<-REV[1,]
REV1<-REV[2,]

cum.rev0<-cumsum(REV0)
cum.rev1<-cumsum(REV1)

df1<-data.frame(marray,cum.rev0,cum.rev1)
g<-ggplot(df1, aes(marray))
g<-g+ geom_line(aes(y=cum.rev0), colour="purple")+geom_line(aes(y=cum.rev1), colour="blue")
g<-g+ylab("Cumulative Revenue in $") + xlab("Game")+ggtitle("Cumulative revenues according to strategies")
g


###############################################################################################
# OTHER STRATEGY COMPARISON: If I get a low pair and two faces shoud I keep the two faces only, 
# the low pair only or one face and the low pair, or the two faces and the low pair?

#Deal the first hand, consisting of a pair of low cards and one face card.
hand6 <- function() {
  #Choose the low pair
  low.rank <- sample(2:10, 1)
  low.color <- sample(colors, size=2, replace=FALSE)
  #Choose a face card.
  face.rank <- sample(11:14, 2)
  face.color <- sample(colors, size=2)
  #Choose the remaining cards. Cannot be the same as the two previous types, cannot have another
  # pair(as replace=FALSE for sample, we won't get another pair)
  rem.ranks <- sample(seq(2, 14)[-c(face.rank-1, low.rank-1)], 1)  
  rem.colors <- sample(colors, size=1, replace=TRUE)
  #Arrange all cards into a hand.
  card.ranks <- c(low.rank, low.rank, face.rank, rem.ranks)
  card.colors <- c(low.color, face.color, rem.colors)
  deck[list(13*(card.colors-1)+card.ranks-1)[[1]]] <- TRUE  
  deck
}

# We set up a new variable choose which refers to the strategy the player chooses
# choose=0, keep only the pair (strategy a)
# choose=1, keep the pair and one face card (strategy b)
# choose=2, keep only both face cards (strategy c)
# choose=3, keep both faces, the pair and only discard the last one (strategy d)
new.hand6<- function(hand,choose) {
  keep<-which(rowSums(hand)==2)
  held<-which(hand & row(hand) == keep)
  if (choose==1){
    keep.t<-intersect(which(hand), which(row(hand) >= 10))
    if (length(keep.t)>1){
      keep2<-sample(keep.t,1)
    }
    else {
      keep2<-keep.t
    }
    held<-c(held,keep2)
  }
  else if (choose==2){
    keep2<-intersect(which(hand), which(row(hand) >= 10))
    held<-keep2
  }
  else if (choose==3){
    keep2<-intersect(which(hand), which(row(hand) >= 10))
    held<-c(held,keep2)   
  }
  discarded <- setdiff(which(hand), held)
  new.c <- sample(which(!hand), size=(5 - length(held)), replace=FALSE)
  hand[discarded] <- FALSE
  hand[new.c] <- TRUE
  hand
}

compare2 <- function(m) {
  testing0<-matrix(0,nrow=1,ncol=20)
  sapply(1:m, function(o)
  {
    hand<-hand6()
    new.hand.choice0<-new.hand6(hand,0)
    new.hand.choice1<-new.hand6(hand,1)
    new.hand.choice2<-new.hand6(hand,2)
    new.hand.choice3<-new.hand6(hand,3)
    if (one.pair(new.hand.choice0)==1){
      testing0[,1]<-testing0[,1]+1
    }
    else if (two.pairs(new.hand.choice0)==1) {
      testing0[,2]<-testing0[,2]+1  
    }
    else if (triple(new.hand.choice0)==1){
      testing0[,3]<-testing0[,3]+1
    }
    else if (full.house(new.hand.choice0)==1){
      testing0[,4]<-testing0[,4]+1
    }
    else if (four(new.hand.choice0)==1){
      testing0[,5]<-testing0[,5]+1
    }
    
    if (one.pair(new.hand.choice1)==1){
      testing0[,6]<-testing0[,6]+1
    }
    else if (two.pairs(new.hand.choice1)==1) {
      testing0[,7]<-testing0[,7]+1  
    }
    else if (triple(new.hand.choice1)==1){
      testing0[,8]<-testing0[,8]+1
    }
    else if (full.house(new.hand.choice1)==1){
      testing0[,9]<-testing0[,9]+1
    }
    else if (four(new.hand.choice1)==1){
      testing0[,10]<-testing0[,10]+1
    }
    
    if (one.pair(new.hand.choice2)==1){
      testing0[,11]<-testing0[,11]+1
    }
    else if (two.pairs(new.hand.choice2)==1) {
      testing0[,12]<-testing0[,12]+1  
    }
    else if (triple(new.hand.choice1)==2){
      testing0[,13]<-testing0[,13]+1
    }
    else if (full.house(new.hand.choice1)==2){
      testing0[,14]<-testing0[,14]+1
    }
    else if (four(new.hand.choice1)==2){
      testing0[,15]<-testing0[,15]+1
    }
    
    if (one.pair(new.hand.choice3)==1){
      testing0[,16]<-testing0[,16]+1
    }
    else if (two.pairs(new.hand.choice3)==1) {
      testing0[,17]<-testing0[,17]+1  
    }
    else if (triple(new.hand.choice3)==1){
      testing0[,18]<-testing0[,18]+1
    }
    else if (full.house(new.hand.choice3)==1){
      testing0[,19]<-testing0[,19]+1
    }
    else if (four(new.hand.choice3)==1){
      testing0[,20]<-testing0[,20]+1
    }
    testing0
  })
}

## Bar plot with losses
M<-100000
count<-rowSums(compare2(M))
count2<-c(M-sum(count[1:5]),count[1:5],M-sum(count[6:10]),count[6:10],M-sum(count[11:15]),count[11:15],M-sum(count[16:20]),count[16:20])
probabilities<-count2/M*100
titles <- c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad")
ttiles<c(titles,titles,titles,titles)
choice<-c('a','a','a','a','a','a','b','b','b','b','b','b','c','c','c','c','c','c','d','d','d','d','d','d')

df<-data.frame(choice,titles,count2,probabilities)
Poker.Hands<-df$titles
qplot(Poker.Hands, df$count2, geom="bar", stat="identity", fill=choice,  position="dodge", alpha = 0.5, ylab="Count", main="Strategy Comparison", 
      labels=c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad"),
      scale_fill_manual(values=c('blue', 'purple'), xlab="Poker Hands",scale_x_discrete(breaks=c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad"))))

## Bar plot without losses
probabilities<-count/M*100
titles <- c("One-pair", "Two-pairs", "Triple", "Full-House","Quad")
choice<-c('a','a','a','a','a','b','b','b','b','b','c','c','c','c','c','d','d','d','d','d')

df<-data.frame(choice,titles,count,probabilities)
Poker.Hands<-df$titles
qplot(Poker.Hands, df$count, geom="bar", stat="identity", fill=choice,  position="dodge", alpha = 0.5, ylab="Count", main="Strategy Comparison", 
      labels=c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad"),
      scale_fill_manual(values=c('blue', 'purple'), xlab="Poker Hands",scale_x_discrete(breaks=c("Loss","One-pair", "Two-pairs", "Triple", "Full-House","Quad"))))

## REVENUE EXPECTATNCY FOR EACH STRATEGY
test.revenue2 <-function(o)
{
  hand<-hand6()
  x<-5
  new.hand.choice0<-new.hand6(hand,0)
  new.hand.choice1<-new.hand6(hand,1)
  new.hand.choice2<-new.hand6(hand,2)
  new.hand.choice3<-new.hand6(hand,3)
  if (one.pair(new.hand.choice0)==1){
    revenue0=jacks.or.better.rev(x)
  }
  else if (two.pairs(new.hand.choice0)==1) {
    revenue0=twopairs.rev(x)
  }
  else if (triple(new.hand.choice0)==1){
    revenue0=triple.rev(x)
  }
  else if (full.house(new.hand.choice0)==1){
    revenue0=full.house.rev(x)
  }
  else if (four(new.hand.choice0)==1){
    revenue0=quad.rev(x)
  }
  else {
    revenue0=none.rev(x)
  }
  
  if (one.pair(new.hand.choice1)==1){
    revenue1=jacks.or.better.rev(x)
  }
  else if (two.pairs(new.hand.choice1)==1) {
    revenue1=twopairs.rev(x) 
  }
  else if (triple(new.hand.choice1)==1){
    revenue1=triple.rev(x)
  }
  else if (full.house(new.hand.choice1)==1){
    revenue1=full.house.rev(x)
  }
  else if (four(new.hand.choice1)==1){
    revenue1=quad.rev(x)
  }
  else {
    revenue1=none.rev(x)
  }
  
  if (one.pair(new.hand.choice2)==1){
    revenue2=jacks.or.better.rev(x)
  }
  else if (two.pairs(new.hand.choice2)==1) {
    revenue2=twopairs.rev(x)
  }
  else if (triple(new.hand.choice2)==1){
    revenue2=triple.rev(x)
  }
  else if (full.house(new.hand.choice2)==1){
    revenue2=full.house.rev(x)
  }
  else if (four(new.hand.choice2)==1){
    revenue2=quad.rev(x)
  }
  else {
    revenue2=none.rev(x)
  }
  
  if (one.pair(new.hand.choice3)==1){
    revenue3=jacks.or.better.rev(x)
  }
  else if (two.pairs(new.hand.choice3)==1) {
    revenue3=twopairs.rev(x)
  }
  else if (triple(new.hand.choice3)==1){
    revenue3=triple.rev(x)
  }
  else if (full.house(new.hand.choice3)==1){
    revenue3=full.house.rev(x)
  }
  else if (four(new.hand.choice3)==1){
    revenue3=quad.rev(x)
  }
  else {
    revenue3=none.rev(x)
  }
  rev<-c(revenue0,revenue1,revenue2,revenue3)
  rev
}

m<-1000
marray<-seq(from=1,to=m,by=1)

REV<-sapply(marray,test.revenue2)
REV0<-REV[1,]
REV1<-REV[2,]
REV2<-REV[3,]
REV3<-REV[4,]

cum.rev0<-cumsum(REV0)
cum.rev1<-cumsum(REV1)
cum.rev2<-cumsum(REV2)
cum.rev3<-cumsum(REV3)

df2<-data.frame(marray,cum.rev0,cum.rev1,cum.rev2,cum.rev3)
g<-ggplot(df2, aes(marray))
g<-g+ geom_line(aes(y=cum.rev0), colour="purple")+geom_line(aes(y=cum.rev1), colour="blue")+geom_line(aes(y=cum.rev2), colour="pink")+geom_line(aes(y=cum.rev3), colour="lightgreen")
g<-g+ylab("Cumulative Revenue in $") + xlab("Game")+ggtitle("Cumulative revenues according to strategies")
g<-g+scale_colour_manual(name='Strategies', values=c('cum.rev0'='purple', 'cum.sum1'='blue'), guide='legend') +guide_legend(label='TRUE')
g

# Purple: strategy a, keep the low pair
# Blue: strategy b, keep the low pair and the face card
# Pink: strategy c, keep the two face cards only
# Green: strategy d, keep the low pair and the two face cards


##################################################################################################
