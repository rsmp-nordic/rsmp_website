---
layout: page
title: Blog
permalink: /blog/
nav_order: 5
---

# Blog

<ol class="blog">
  {% for post in site.posts %}
    <li>
      <h4>{{ post.date | date_to_string }}</h4>
      <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
      {{ post.excerpt }}
    </li>
  {% endfor %}
</ol>
