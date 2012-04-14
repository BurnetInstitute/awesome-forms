jQuery.fn.markItUpMarkdown = function()
{
	$(this).markItUp(
	{
		onShiftEnter: {keepDefault: false, openWith: '  \n'},
		markupSet:
		[
			{name: 'Heading', openWith: '### ', placeHolder: 'Heading', className: 'heading'},
			{name: 'Subheading', openWith: '#### ', placeHolder: 'Subheading', className: 'subheading'},
			{separator: '---------------'},
			{name: 'Bold', openWith: '**', closeWith: '**', className: 'bold'},
			{name: 'Italic', openWith: '_', closeWith: '_', className: 'italic'},
			{separator: '---------------'},
			{name: 'Bulleted List', openWith: '- ', multiline: true, className: 'unordered-list'},
			{name: 'Numbered List', openWith: function(markItUp) {return markItUp.line+'. ';}, multiline: true, className: 'ordered-list'},
			{name: 'Block Quote', openWith: '> ', multiline: true, className: 'block-quote'},
			{separator: '---------------'},
			{name: 'Link', openWith: '[', closeWith: ']([![URL:!:http://]!] "[![Title]!]")', placeHolder: 'Label', className: 'link'},
			{name: 'Image', replaceWith:'![[![Alternative Text]!]]([![URL:!:http://]!] "[![Title]!]")', className: 'image'},
			{name: 'Media', replaceWith:'*([![URL:!:http://]!])', className: 'media'}
		]
	});
}