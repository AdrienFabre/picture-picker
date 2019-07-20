# Picture Picker

This program has been created to enable the selection of the most similar pictures from a list of pictures. Those pictures have been labelled with Google Vision API. (example in the JSON file)

## Use case

A user posts a picture on an app, we might assume that they would be interested in posts similar to theirs, or at least referring to similar content. One way to do this might be to find other posts with similar images to theirs.

As an example, we have made 20 plant images available and their dataset of labels from the Google Cloud Vision API for those images
(see `data.json`).

## Challenge

If I were to post any one of the 20 images, which of the other 19 would be relevant to show to me as "other posts like yours"?

Write an algorithm that uses the data we provide to figure out which images are most similar.

## Approach

To begin, I searched how data could be used to compare those pictures. I found that picture has a list of labels that contains 2 key information:

- the label description (which is what Google Cloud API identifies)

- the score (which is the confidence the ML model has in its relevance)

I started to only use the label and create the algorithm, then I added the score.

- 1 - I gather the information about the picture we want to find a similar picture to. I call it 'Selected picture'. In this peticular case this is one picture from the data file. In a real situation the posted picture would go through the Google Cloud Vision API and return the same data format. So, I go through the data and get the description from each label, which gives me the targeted descriptions. Here I could narrow down those descriptions by taking only thoses with a score higher than 0.85 for example, so, I would optimize it's efficiency.

- 2 - I gather the information about the picture we already have in order to show the most relevant one. Here, this is where there is a higher level of complexity because we have to run the same algorithm as for one picture but for all pictures. However, we could already have all pictures that we already have already stored with the 2 only information we need, and we could place filters to reduce the number of pictures, such as date posted, location or number of likes.

- 3 - I rank every other picture in comparison to the posted picture. Here, I go through every description of every picture and I increment the rank if the description matches, on average, this file has 10 descriptions for one picture. So, if I compare 1 picture to 1 picture, I would go through 10 times 10 comparisons, so 100. For, 20 pictures, I would go through 10 times 200 comparisons, so 2000. This is where the algorithm is the weakest. This is why I decided to add the option to filter by score, which could divide by half the complexity. Then the filter of the orginal batch of pictures could go in the same direction.

## Technology

Ruby

Rspec

## Install

```md
bundle install
```

## Test

### Run

```md
rspec
```

### Results

```md
PicturePicker
  select the most similar images
    taking into account only the description
      retuns the picture with the highest similarity score
      retuns 3 pictures with the highest similarity score
    taking into account the description and the score
      retuns the picture with the highest similarity score
      retuns 3 pictures with the highest similarity score

Finished in 0.01217 seconds (files took 0.08182 seconds to load)
4 examples, 0 failures
```

## Execute Linter auto-correct

```md
bundle exec rbprettier --write '**/*.rb'
```
